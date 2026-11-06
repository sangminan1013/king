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
      return error.message;
    } catch (_) {
      return "게스트 세션을 만들지 못했습니다. 네트워크 연결을 확인해 주세요.";
    }
  }

  Future<void> signOut() => _client.auth.signOut();
}
