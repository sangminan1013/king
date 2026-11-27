const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789'

export const normalizeInviteCode = (code: string): string => {
  const trimmed = code.trim()
  // Old KING codes were case-insensitive. New six-character codes are exact.
  return /^KING-[A-Z0-9]{3}$/i.test(trimmed) ? trimmed.toUpperCase() : trimmed
}

export const randomInviteCode = (): string => {
  const cutoff = Math.floor(256 / alphabet.length) * alphabet.length
  while (true) {
    let code = ''
    while (code.length < 6) {
      const bytes = crypto.getRandomValues(new Uint8Array(12))
      for (const byte of bytes) {
        if (byte >= cutoff) continue
        code += alphabet[byte % alphabet.length]
        if (code.length === 6) break
      }
    }
    if (/[A-Z]/.test(code) && /[a-z]/.test(code) && /[2-9]/.test(code)) return code
  }
}
