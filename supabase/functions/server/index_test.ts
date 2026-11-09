import { app } from './index.tsx'
import { isRoomReady } from './readiness.ts'

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
  options: { members?: string[]; authors?: string[]; stored?: boolean; closed?: boolean },
  run: (state: { aiCalls: number; writes: number }, request: (path?: string, method?: string, user?: string) => Promise<Response>) => Promise<void>,
) {
  const members = options.members ?? ['a', 'b']
  const authors = options.authors ?? ['a', 'b']
  let stored = options.stored ?? false
  const state = { aiCalls: 0, writes: 0 }
  const originalFetch = globalThis.fetch
  const json = (data: unknown) => new Response(JSON.stringify(data), { headers: { 'Content-Type': 'application/json' } })
  globalThis.fetch = async (input, init) => {
    const req = new Request(input, init)
    const url = new URL(req.url)
    if (url.host === 'openrouter.ai') {
      state.aiCalls++
      return json({ choices: [{ message: { content: JSON.stringify({ ...verdict, fitScore: 80 }) } }] })
    }
    if (url.pathname === '/auth/v1/user') {
      const id = req.headers.get('Authorization')?.replace('Bearer ', '') ?? 'a'
      return json({ id, aud: 'authenticated', role: 'authenticated', app_metadata: {}, user_metadata: {} })
    }
    const table = url.pathname.split('/').at(-1)
    if (req.method !== 'GET') {
      state.writes++
      if (table === 'verdicts') stored = true
      return new Response(null, { status: 201 })
    }
    if (table === 'rooms') return json([{
      id: 'room-1', invite_code: 'KING-ABC', owner_id: 'a', group_name: '그룹', topic: '안건',
      member_limit: 2, status: options.closed ? 'finalized' : 'collecting',
    }])
    if (table === 'room_members') {
      const user = url.searchParams.get('user_id')?.replace('eq.', '')
      return json(members.filter((id) => !user || id === user).map((id) => ({ user_id: id, room_id: 'room-1' })))
    }
    if (table === 'opinions') return json(authors.map((id) => ({ author_id: id, content: `참여자 ${id}의 충분히 긴 의견입니다.`, submitted_at: '2026-11-09T00:00:00Z' })))
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
    assert(state.aiCalls === 1 && state.writes === 1)
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
