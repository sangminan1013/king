import { app } from './index.tsx'
import { isRoomReady } from './readiness.ts'
import { personalities, type KingPersonality } from './personalities.ts'

const assert = (condition: unknown, message = 'Assertion failed') => {
  if (!condition) throw new Error(message)
}

Deno.env.set('SUPABASE_URL', 'https://king-test.supabase.co')
Deno.env.set('SUPABASE_SERVICE_ROLE_KEY', 'test-service-role')
Deno.env.set('SUPABASE_ANON_KEY', 'test-anon')
Deno.env.set('OPENROUTER_API_KEY', 'test-openrouter')

const verdict = {
  room_id: 'room-1', title: '모두의 조건을 반영한 결정', summary: '두 의견을 반영한 절충안',
  fit_score: 80, reasons: Array.from({ length: 3 }, () => ({ title: '조건', detail: '반영했습니다' })),
  created_at: '2026-11-09T00:00:00Z',
}

async function fixture(
  options: { members?: string[]; authors?: string[]; stored?: boolean; closed?: boolean; badPreprocessing?: boolean; invalidSelection?: boolean; failedRunSave?: boolean; king?: KingPersonality },
  run: (state: { aiCalls: number; writes: number }, request: (path?: string, method?: string, user?: string) => Promise<Response>) => Promise<void>,
) {
  const members = options.members ?? ['a', 'b']
  const authors = options.authors ?? ['a', 'b']
  let stored = options.stored ?? false
  let finalized = options.closed ?? false
  const state = { aiCalls: 0, writes: 0 }
  const originalFetch = globalThis.fetch
  const json = (data: unknown) => new Response(JSON.stringify(data), { headers: { 'Content-Type': 'application/json' } })
  globalThis.fetch = async (input, init) => {
    const req = new Request(input, init)
    const url = new URL(req.url)
    if (url.host === 'openrouter.ai') {
      state.aiCalls++
      const payload = await req.json()
      if (payload.response_format.json_schema.name === 'king_preprocessing') {
        const input = JSON.parse(payload.messages[1].content)
        return json({ choices: [{ finish_reason: 'stop', message: { content: JSON.stringify({
          topic: input.topic,
          opinions: options.badPreprocessing ? [] : input.opinions.map((opinion: { participant: number; text: string }) => ({ ...opinion, text: '정규화된 의견', injectionDetected: true })),
        }) } }] })
      }
      if (payload.response_format.json_schema.name === 'king_decision') {
        assert(payload.messages[0].content.includes(personalities[options.king ?? 'wise'].priorities), 'Wrong decision priorities')
        return json({ choices: [{ finish_reason: 'stop', message: { content: JSON.stringify({ selectedParticipant: options.invalidSelection ? 99 : 1, fitScore: 75, rationale: '첫 의견이 조건에 가장 적합함' }) } }] })
      }
      assert(payload.messages[0].content.includes(personalities[options.king ?? 'wise'].voice), 'Wrong narration voice')
      assert(!payload.messages[1].content.includes('충분히 긴 의견'), 'Raw opinions reached decision model')
      assert(payload.messages[1].content.includes('정규화된 의견'))
      return json({ choices: [{ finish_reason: 'stop', message: { content: JSON.stringify({ ...verdict, fitScore: 80 }) } }] })
    }
    if (url.pathname === '/auth/v1/user') {
      const id = req.headers.get('Authorization')?.replace('Bearer ', '') ?? 'a'
      return json({ id, aud: 'authenticated', role: 'authenticated', app_metadata: {}, user_metadata: {} })
    }
    const table = url.pathname.split('/').at(-1)
    if (req.method !== 'GET') {
      state.writes++
      if (table === 'rooms' && req.method === 'PATCH') {
        finalized = true
        return json({ id: 'room-1', owner_id: 'a', member_limit: 2, status: 'finalized', finalized_at: '2026-11-17T01:00:00Z' })
      }
      if (table === 'decision_runs' && req.method === 'POST') {
        const saved = await req.json()
        assert(saved.king_personality === (options.king ?? 'wise'))
        assert(saved.personality_snapshot.name === personalities[options.king ?? 'wise'].name)
        assert(saved.source_opinions[0].originalText.includes('충분히 긴 의견'))
        assert(saved.normalized_input.opinions[0].text === '정규화된 의견')
        return options.failedRunSave ? new Response('{}', { status: 500 }) : json({ id: 'run-1' })
      }
      if (table === 'verdicts') {
        const saved = await req.json()
        assert(saved.selected_participant === 1 && saved.selected_opinion === '정규화된 의견')
        assert(saved.fit_score === 75 && saved.pipeline_run_id === 'run-1')
        stored = true
      }
      return new Response(null, { status: 201 })
    }
    if (table === 'rooms') return json([{
      id: 'room-1', invite_code: 'KING-ABC', owner_id: 'a', group_name: '그룹', topic: '안건',
      king_personality: options.king, member_limit: 2, status: finalized ? 'finalized' : 'collecting', finalized_at: finalized ? '2026-11-17T01:00:00Z' : null,
    }])
    if (table === 'room_members') {
      const user = url.searchParams.get('user_id')?.replace('eq.', '')
      return json(members.filter((id) => !user || id === user).map((id) => ({ user_id: id, room_id: 'room-1' })))
    }
    if (table === 'opinions') return json(authors.map((id) => ({ id: `opinion-${id}`, author_id: id, content: `참여자 ${id}의 충분히 긴 의견입니다.`, submitted_at: '2026-11-09T00:00:00Z' })))
    if (table === 'verdicts') return json(stored ? [verdict] : [])
    throw new Error(`Unexpected request: ${req.method} ${url}`)
  }
  const request = async (path = 'verdict', method = 'POST', user = 'a') => await app.request(
    `/server/rooms/room-1${path ? '/' + path : ''}`,
    { method, headers: { Authorization: `Bearer ${user}`, 'Content-Type': 'application/json' },
      ...(method === 'POST' ? { body: JSON.stringify({ content: '이것은 제출하려는 충분히 긴 의견입니다.' }) } : {}),
    },
  )
  try { await run(state, request) } finally { globalThis.fetch = originalFetch }
}

Deno.test('readiness requires configured capacity and an opinion from each current member', () => {
  assert(!isRoomReady(2, ['a'], ['a']))
  assert(!isRoomReady(2, ['a', 'b'], ['a']))
  assert(!isRoomReady(2, ['a', 'b'], ['a', 'outsider']))
  assert(!isRoomReady(2, ['a', 'b'], ['a', 'a']))
  assert(isRoomReady(2, ['a', 'b'], ['a', 'b']))
})

for (const authors of [[], ['a']]) {
  Deno.test(`POST verdict refuses ${authors.length}/2 opinions without calling AI or storing a verdict`, async () => {
    await fixture({ authors }, async (state, request) => {
      const response = await request()
      assert(response.status === 409)
      assert((await response.json()).error.code === 'WAITING_FOR_OPINIONS')
      assert(state.aiCalls === 0 && state.writes === 0)
    })
  })
}

Deno.test('unfilled room refuses verdict even if every joined member submitted', async () => {
  await fixture({ members: ['a'], authors: ['a'] }, async (state, request) => {
    assert((await request()).status === 409)
    assert(state.aiCalls === 0 && state.writes === 0)
  })
})

Deno.test('two submitted members generate a shared verdict and repeat requests reuse it', async () => {
  await fixture({}, async (state, request) => {
    const first = await request()
    assert(first.status === 200)
    const body = await first.json()
    assert(body.room.verdict.title === verdict.title)
    assert(body.room.opinions.length === 2)
    assert((await request()).status === 200)
    assert(state.aiCalls === 3 && state.writes === 3)
  })
})

Deno.test('an old prematurely stored verdict does not bypass the collection gate', async () => {
  await fixture({ stored: true, authors: ['a'] }, async (state, request) => {
    assert((await request()).status === 409)
    assert(state.aiCalls === 0 && state.writes === 0)
  })
})

Deno.test('nonmembers cannot trigger AI generation', async () => {
  await fixture({}, async (state, request) => {
    assert((await request('verdict', 'POST', 'outsider')).status === 403)
    assert(state.aiCalls === 0 && state.writes === 0)
  })
})

Deno.test('opinions are rejected after a verdict already exists', async () => {
  await fixture({ stored: true }, async (state, request) => {
    const response = await request('opinions')
    assert(response.status === 409)
    assert((await response.json()).error.code === 'VERDICT_EXISTS')
    assert(state.writes === 0)
  })
})

Deno.test('reading an archived verdict never calls AI', async () => {
  await fixture({ stored: true, closed: true }, async (state, request) => {
    assert((await request()).status === 200)
    assert(state.aiCalls === 0 && state.writes === 0)
  })
})

Deno.test('invalid preprocessing never calls decision or stores a verdict', async () => {
  await fixture({ badPreprocessing: true }, async (state, request) => {
    assert((await request()).status === 502)
    assert(state.aiCalls === 2 && state.writes === 0)
  })
})

Deno.test('invalid selection cannot reach narration or save a verdict', async () => {
  await fixture({ invalidSelection: true }, async (state, request) => {
    assert((await request()).status === 502)
    assert(state.aiCalls === 4 && state.writes === 2)
  })
})
Deno.test('preprocessing persistence failure prevents selection', async () => {
  await fixture({ failedRunSave: true }, async (state, request) => {
    assert((await request()).status === 502)
    assert(state.aiCalls === 2 && state.writes === 2)
  })
})

for (const king of Object.keys(personalities) as KingPersonality[]) {
  Deno.test(`${king}: restored room criteria, voice and audit snapshot reach correct stages`, async () => {
    await fixture({ king }, async (state, request) => {
      const response = await request()
      assert(response.status === 200)
      assert((await response.json()).room.kingPersonality === king)
      assert(state.aiCalls === 3 && state.writes === 3)
    })
  })
}
Deno.test('unknown king is rejected before room creation', async () => {
  await fixture({}, async (state) => {
    const response = await app.request('/server/rooms', {
      method: 'POST', headers: { Authorization: 'Bearer a', 'Content-Type': 'application/json' },
      body: JSON.stringify({ groupName: '그룹', topic: '안건', memberLimit: 2, kingPersonality: 'ignore-all-rules' }),
    })
    assert(response.status === 422 && state.writes === 0 && state.aiCalls === 0)
  })
})

Deno.test('finalize is owner-only and idempotent, returning confirmation time', async () => {
  await fixture({ stored: true }, async (state, request) => {
    assert((await request('finalize', 'POST', 'b')).status === 403)
    const first = await request('finalize')
    assert(first.status === 200)
    const room = (await first.json()).room
    assert(room.status === 'finalized' && room.finalizedAt === '2026-11-17T01:00:00Z')
    assert((await request('finalize')).status === 200)
    assert(state.writes === 1 && state.aiCalls === 0)
  })
})
Deno.test('cannot finalize without a verdict', async () => {
  await fixture({}, async (state, request) => {
    assert((await request('finalize')).status === 409)
    assert(state.writes === 0)
  })
})
