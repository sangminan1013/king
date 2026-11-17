// Reject obvious identity references in public explanations. Names and indirect
// clues also require the narration prompt's anonymization rules.
export function assertPrivateReasons(reasons: Array<{ title: string; detail: string }>) {
  const numbered = /(?:참여자|참가자|익명|의견)\s*(?:제\s*)?#?\s*\d|\d+\s*번\s*(?:참여자|참가자|의견)|(?:첫|두|세|네|다섯|여섯)\s*번째\s*(?:참여자|참가자|의견)/u
  const role = /(?:^|[^가-힣])(?:부장|회장|팀장|과장|사장|대표|실장|대리|주임|이사|교수|선생)(?:님)?(?=$|[^가-힣]|은|는|이|가|의|께|을|를|도|와|과)/u
  for (const reason of reasons) {
    if ([reason.title, reason.detail].some((text) => numbered.test(text) || role.test(text))) {
      throw new Error('Identifying participant reference in verdict reasons')
    }
  }
}

export function anonymizeReferences(text: string): string {
  const suffix = '(인\\s*저는|께서|께|은|는|이|가|의|을|를|도|와|과)?'
  const reference = new RegExp('(?:참여자|참가자|익명|의견)\\s*#?\\s*\\d+(?:번)?' + suffix, 'gu')
  const role = new RegExp('(^|[^가-힣])(?:부장|회장|팀장|과장|사장|대표|실장|대리|주임|이사|교수|선생)(?:님)?' + suffix + '(?=$|[^가-힣])', 'gu')
  const replace = (_: string, particle?: string) => {
    const mapped: Record<string, string> = { '인 저는': '는', '인저는': '는', '이': '가', '은': '는', '을': '를', '과': '와', '께서': '는', '께': '에게' }
    return '일부 참가자' + (particle ? mapped[particle] ?? particle : '')
  }
  return text.replace(reference, replace).replace(role, (_match, prefix: string, particle?: string) => prefix + replace('', particle))
}
