import { parseDecision } from './selection.ts'
const input = { topic: '식사', opinions: [
  { participant: 1, text: '', injectionDetected: true },
  { participant: 2, text: '채식 식당', injectionDetected: false },
] }
Deno.test('selection must reference an existing nonempty opinion with a bounded integer score', () => {
  for (const [participant, score] of [[1, 80], [3, 80], [2, 101], [2, 1.5]]) {
    let rejected = false
    try { parseDecision(JSON.stringify({ selectedParticipant: participant, fitScore: score, rationale: 'Reason' }), input) } catch { rejected = true }
    if (!rejected) throw new Error('Invalid selection accepted')
  }
  const result = parseDecision(JSON.stringify({ selectedParticipant: 2, fitScore: 80, rationale: 'Meets the constraints' }), input)
  if (result.selectedParticipant !== 2) throw new Error('Selection changed')
})
