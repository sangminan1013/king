import { assertEnglishText, boundedSentence } from './language.ts'
import { personalities, narrationPersonalityPrompt, decisionPersonalityPrompt } from './personalities.ts'
Deno.test('English guard accepts amounts and romanized names, rejects Hangul leakage', () => {
  assertEnglishText('Choose bibimbap in Seoul for KRW 10,000, not USD 10,000.')
  for (const text of ['비빔밥', 'Choose bibimbap (비빔밥).', '\u1100\u1161']) {
    let rejected = false
    try { assertEnglishText(text) } catch { rejected = true }
    if (!rejected) throw new Error('Hangul passed the English output guard')
  }
})
Deno.test('all rulers retain distinct English voices and anonymous output instructions', () => {
  const starts = new Set<string>()
  for (const id of Object.keys(personalities) as Array<keyof typeof personalities>) {
    const p = personalities[id], prompt = narrationPersonalityPrompt(id)
    assertEnglishText(prompt); assertEnglishText(decisionPersonalityPrompt(id))
    if (!prompt.includes(p.declaration) || !prompt.includes('some participants') || !prompt.includes('MUST be in English')) throw new Error('Output contract lost')
    starts.add(p.declaration)
  }
  if (starts.size !== 5) throw new Error('Distinct declarations lost')
})

Deno.test('long English explanations end at a complete sentence', () => {
  const result = boundedSentence('I decree: choose the riverside restaurant. ' + 'Further details '.repeat(40), 100)
  if (result !== 'I decree: choose the riverside restaurant.') throw new Error('Sentence was cut')
  let rejected = false
  try { boundedSentence('word '.repeat(100), 100) } catch { rejected = true }
  if (!rejected) throw new Error('Incomplete long sentence accepted')
})
