import test from 'node:test';
import assert from 'node:assert/strict';
import { createApp } from '../src/app.js';

test('방 공유, 입력 검증, 결과, 다음 안건, 최종 기록', async (t) => {
  const server = createApp();
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  t.after(() => new Promise(resolve => server.close(resolve)));
  const base = `http://127.0.0.1:${server.address().port}`;
  const call = async (path, body, expected = 200) => {
    const res = await fetch(base + path, body === undefined ? {} : {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body),
    });
    assert.equal(res.status, expected);
    return res.json();
  };
  await call('/rooms', { name: '', topic: '주제', capacity: 4 }, 400);
  await call('/rooms', { name: '팀', topic: '주제', capacity: 21 }, 400);
  await call('/rooms', null, 400);
  await call('/rooms/XXXXXX', undefined, 404);
  const room = await call('/rooms', { name: '팀', topic: '점심', capacity: 2 }, 201);
  assert.match(room.code, /^[A-F0-9]{6}$/);
  const path = `/rooms/${room.code}`;
  assert.equal((await call(path.toLowerCase())).name, '팀');
  await call(`${path}/result`, {}, 400);
  await call(`${path}/next`, {}, 409);
  const opinion = { author: '민수', condition: '1만원', text: ' 비빔밥 ' };
  await call(`${path}/opinions`, opinion);
  await call(`${path}/opinions`, opinion, 409);
  await call(`${path}/opinions`, { ...opinion, author: '지수' });
  await call(`${path}/opinions`, { ...opinion, author: '영수' }, 409);
  assert.equal((await call(path)).opinions[0].text, '비빔밥');
  const result = await call(`${path}/result`, {});
  assert.match(result.result, /실제 AI 분석이 아닙니다/);
  await call(`${path}/opinions`, { ...opinion, author: '영수' }, 409);
  const next = await call(`${path}/next`, {});
  assert.equal(next.round, 2);
  assert.equal(next.history.length, 1);
  assert.deepEqual(next.opinions, []);
  await call(`${path}/opinions`, opinion);
  await call(`${path}/result`, {});
  const closed = await call(`${path}/finish`, {});
  assert.equal(closed.closed, true);
  assert.equal(closed.history.length, 2);
  await call(`${path}/next`, {}, 409);
  const malformed = await fetch(base + '/rooms', { method: 'POST', body: '{' });
  assert.equal(malformed.status, 400);
  const tooLarge = await fetch(base + '/rooms', { method: 'POST', body: 'x'.repeat(20000) });
  assert.equal(tooLarge.status, 413);
});
