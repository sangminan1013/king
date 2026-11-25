// Korean/English input is accepted; generated text is English-only. This guard
// catches Hangul leakage, not every possible non-English word or semantic error.
export function assertEnglishText(text: string) {
  if (/\p{Script=Hangul}/u.test(text)) throw new Error('Generated text must be in English; Hangul is not allowed')
}

// English is often longer than the original Korean. Never save half a word or
// sentence when retaining the existing database's character limits.
export function boundedSentence(value: unknown, maxLength: number): string {
  if (typeof value !== 'string') return ''
  const text = value.trim()
  if (text.length <= maxLength) return text
  const matches = [...text.slice(0, maxLength + 1).matchAll(/[.!?](?=\s|$)/gu)]
  const end = matches.at(-1)?.index
  if (end === undefined || end >= maxLength) throw new Error('English explanation exceeds the sentence limit')
  return text.slice(0, end + 1)
}
