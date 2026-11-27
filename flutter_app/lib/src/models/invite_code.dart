String normalizeInviteCode(String code) {
  final trimmed = code.trim();
  if (RegExp(r'^KING-[A-Z0-9]{3}$', caseSensitive: false).hasMatch(trimmed)) {
    return trimmed.toUpperCase();
  }
  return RegExp(r'^[A-Z0-9]{4}$', caseSensitive: false).hasMatch(trimmed)
      ? trimmed.toLowerCase()
      : trimmed;
}
