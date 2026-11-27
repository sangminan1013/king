import { app } from './index.tsx'
import { normalizeInviteCode, randomInviteCode } from './invite_codes.ts'

const assert = (ok: unknown, message = 'Assertion failed') => {
  if (!ok) throw new Error(message)
}

Deno.test('short codes contain four unambiguous lowercase letters and digits', () => {
  for (let i = 0; i < 300; i++) {
    const code = randomInviteCode()
    assert(/^[a-km-np-z2-9]{4}$/.test(code), `Invalid code: ${code}`)
    assert(/[a-z]/.test(code) && /[2-9]/.test(code))
    assert(!code.includes('-'))
  }
})

Deno.test('normalization lowercases four-character codes and preserves legacy formats', () => {
  assert(normalizeInviteCode(' AB7X ') === 'ab7x')
  assert(normalizeInviteCode(' aB7xQ2 ') === 'aB7xQ2')
  assert(normalizeInviteCode('ab7xq2') !== normalizeInviteCode('aB7xQ2'))
  assert(normalizeInviteCode(' king-abc ') === 'KING-ABC')
})

Deno.env.set('SUPABASE_URL', 'https://king-test.supabase.co')
Deno.env.set('SUPABASE_SERVICE_ROLE_KEY', 'test-service-role')
Deno.env.set('SUPABASE_ANON_KEY', 'test-anon')

async function withRoom(
  code: string,
  run: (state: { inserted: string[]; requested: string[]; recovered: boolean }, request: (path: string, body: unknown) => Promise<Response>) => Promise<void>,
) {
  const state = { inserted: [] as string[], requested: [] as string[], recovered: false }
  const originalFetch = globalThis.fetch
  const json = (value: unknown, status = 200) => new Response(JSON.stringify(value), {
    status, headers: { 'Content-Type': 'application/json' },
  })
  const room = () => ({ id: 'room', invite_code: code, owner_id: 'host', group_name: '팀', topic: '안건', member_limit: 2, status: 'collecting', king_personality: 'wise' })
  globalThis.fetch = async (input, init) => {
    const request = new Request(input, init)
    const url = new URL(request.url)
    if (url.pathname === '/auth/v1/user') return json({ id: 'host', app_metadata: {}, user_metadata: {} })
    const table = url.pathname.split('/').at(-1)
    if (table === 'join_room_by_code') {
      const payload = await request.json()
      state.requested.push(payload.requested_code)
      return payload.requested_code === code
        ? json('room')
        : json({ code: 'P0002', message: 'Room not found' }, 404)
    }
    if (table === 'reclaim_room_ownership') {
      state.recovered = true
      return json(true)
    }
    if (table === 'rooms' && request.method === 'POST') {
      const payload = await request.json()
      state.inserted.push(payload.invite_code)
      code = payload.invite_code
      return json(room(), 201)
    }
    if (table === 'room_owner_recovery') return new Response(null, { status: 201 })
    if (table === 'rooms') {
      const requested = url.searchParams.get('invite_code')?.replace('eq.', '')
      if (requested) state.requested.push(requested)
      return json(!requested || requested === code ? [room()] : [])
    }
    if (table === 'room_members') return json([{ room_id: 'room', user_id: 'host' }])
    if (table === 'opinions' || table === 'verdicts') return json([])
    throw new Error(`Unexpected request: ${request.method} ${url}`)
  }
  const request = async (path: string, body: unknown) => await app.request(`/server/${path}`, {
    method: 'POST', headers: { Authorization: 'Bearer host', 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
  try { await run(state, request) } finally { globalThis.fetch = originalFetch }
}

Deno.test('room creation stores and returns a short code', async () => {
  await withRoom('', async (state, request) => {
    const response = await request('rooms', { groupName: '팀', topic: '안건', memberLimit: 2 })
    assert(response.status === 201)
    const body = await response.json()
    assert(state.inserted.length === 1)
    assert(body.room.code === state.inserted[0] && body.room.code.length === 4)
    assert(typeof body.ownerToken === 'string')
  })
})

Deno.test('join preserves exact case in the database RPC', async () => {
  await withRoom('aB7xQ2', async (state, request) => {
    const response = await request('rooms/join', { code: ' aB7xQ2 ' })
    assert(response.status === 200)
    assert(state.requested[0] === 'aB7xQ2')
    assert((await response.json()).room.code === 'aB7xQ2')
  })
})

Deno.test('previous six-character codes remain case-sensitive', async () => {
  await withRoom('aB7xQ2', async (_, request) => {
    assert((await request('rooms/join', { code: 'ab7xq2' })).status === 404)
  })
})

Deno.test('legacy KING codes still accept lowercase input', async () => {
  await withRoom('KING-ABC', async (state, request) => {
    assert((await request('rooms/join', { code: 'king-abc' })).status === 200)
    assert(state.requested[0] === 'KING-ABC')
  })
})

Deno.test('owner recovery looks up the mixed-case code without uppercasing it', async () => {
  await withRoom('aB7xQ2', async (state, request) => {
    assert((await request('rooms/join', { code: 'aB7xQ2', ownerToken: 'device-token' })).status === 200)
    assert(state.requested[0] === 'aB7xQ2' && state.recovered)
  })
})

Deno.test('four-character codes accept uppercase input and reuse lowercase recovery keys', async () => {
  await withRoom('ab7x', async (state, request) => {
    assert((await request('rooms/join', { code: 'AB7X' })).status === 200)
    assert(state.requested[0] === 'ab7x')
    assert((await request('rooms/join', { code: 'AB7X', ownerToken: 'device-token' })).status === 200)
    assert(state.recovered)
  })
})
