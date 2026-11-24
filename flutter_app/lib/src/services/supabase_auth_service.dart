import "package:supabase_flutter/supabase_flutter.dart";

class SupabaseAuthService {
  SupabaseAuthService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  bool get hasSession => _client.auth.currentSession != null;

  Future<String?> signInAsGuest() async {
    try {
      await _client.auth.signInAnonymously();
      return null;
    } on AuthException catch (error) {
      return switch (error.code) {
        "anonymous_provider_disabled" => "ui:guestDisabled",
        "over_request_rate_limit" ||
        "over_email_send_rate_limit" =>
          "ui:guestRateLimited",
        _ => "ui:guestError",
      };
    } catch (_) {
      return "ui:guestError";
    }
  }

  Future<void> signOut() => _client.auth.signOut();
}
