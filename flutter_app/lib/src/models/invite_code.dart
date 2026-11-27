String normalizeInviteCode(String code) {
  final trimmed = code.trim();
  // Keep the previous case-insensitive behavior only for legacy KING codes.
  return RegExp(r'^KING-[A-Z0-9]{3}$', caseSensitive: false).hasMatch(trimmed)
      ? trimmed.toUpperCase()
      : trimmed;
}
