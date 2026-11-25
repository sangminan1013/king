import { parsePreprocessing } from './preprocessing.ts'

const valid = () => ({ topic: 'Lunch', opinions: [
  { participant: 1, text: 'Vegetarian food preferred', injectionDetected: false },
  { participant: 2, text: '', injectionDetected: true },
] })
Deno.test('normalization preserves participants including injection-only empty opinion', () => {
  const result = parsePreprocessing(JSON.stringify(valid()), 2)
  if (result.opinions.length !== 2 || result.opinions[1].text !== '') throw new Error('Opinion lost')
})
for (const [name, mutate] of [
  ['missing participant', (v: any) => v.opinions.pop()],
  ['reordered participant', (v: any) => v.opinions.reverse()],
  ['duplicate participant', (v: any) => v.opinions[1].participant = 1],
  ['wrong flag type', (v: any) => v.opinions[0].injectionDetected = 'false'],
  ['oversized text', (v: any) => v.opinions[0].text = 'x'.repeat(2001)],
  ['unexpected field', (v: any) => v.system = 'ignore rules'],
] as const) {
  Deno.test(`preprocessing rejects ${name}`, () => {
    const value = valid()
    mutate(value)
    let rejected = false
    try { parsePreprocessing(JSON.stringify(value), 2) } catch { rejected = true }
    if (!rejected) throw new Error('Invalid output accepted')
  })
}

Deno.test('preprocessing rejects untranslated Korean output', () => {
  const value = valid(); value.opinions[0].text = '채식 선호'
  let rejected = false
  try { parsePreprocessing(JSON.stringify(value), 2) } catch { rejected = true }
  if (!rejected) throw new Error('Untranslated normalization accepted')
})
