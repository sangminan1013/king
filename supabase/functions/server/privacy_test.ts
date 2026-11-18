import { assertPrivateReasons, anonymizeReferences } from './privacy.ts'
Deno.test('public reasons reject participant numbers and identifying roles', () => {
  for (const detail of ['참여자 1은 비용을 우려했다', '2번 참가자의 의견이다', '첫 번째 의견을 따른다', '부장님은 거리가 멀다 했다', '회장의 의견에 따른다']) {
    let rejected = false
    try { assertPrivateReasons([{ title: '이유', detail }]) } catch { rejected = true }
    if (!rejected) throw new Error(`Identity reference passed: ${detail}`)
  }
  assertPrivateReasons([{ title: '비용 부담 완화', detail: '일부 참가자는 비용을 우려하였느니라. 대표적인 부담을 줄인 선택이니라.' }])
})

Deno.test('narration input removes identifying references while preserving conditions', () => {
  const safe = anonymizeReferences('참여자 1의 비용 제약과 부장인 저는 국밥을 원합니다. 회장은 야경을 원합니다.')
  assertPrivateReasons([{ title: '조건', detail: safe }])
  if (!safe.includes('비용 제약') || !safe.includes('국밥') || !safe.includes('야경')) throw new Error('Preference lost')
})
