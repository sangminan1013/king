const alphabet = 'abcdefghijkmnpqrstuvwxyz23456789'

export const normalizeInviteCode = (code: string): string => {
  const trimmed = code.trim()
  // New four-character codes are lowercase; preserve older six-character codes.
  if (/^KING-[A-Z0-9]{3}$/i.test(trimmed)) return trimmed.toUpperCase()
  return /^[A-Z0-9]{4}$/i.test(trimmed) ? trimmed.toLowerCase() : trimmed
}

export const randomInviteCode = (): string => {
  const cutoff = Math.floor(256 / alphabet.length) * alphabet.length
  while (true) {
    let code = ''
    while (code.length < 4) {
      const bytes = crypto.getRandomValues(new Uint8Array(12))
      for (const byte of bytes) {
        if (byte >= cutoff) continue
        code += alphabet[byte % alphabet.length]
        if (code.length === 4) break
      }
    }
    if (/[a-z]/.test(code) && /[2-9]/.test(code)) return code
  }
}
