import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:king/src/controller/king_controller.dart';
import 'package:king/src/services/king_api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/models/invite_code.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('controller and API preserve code case and use separate recovery keys', () async {
    FlutterSecureStorage.setMockInitialValues({
      'king.room-owner.aB7xQ2': 'mixed-token',
      'king.room-owner.ab7xq2': 'lower-token',
      'king.room-owner.KING-ABC': 'legacy-token',
    });
    final token = 'e30.${base64Url.encode(utf8.encode(jsonEncode({
      'sub': 'guest',
      'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    }))).replaceAll('=', '')}.signature';
    final client = SupabaseClient('https://example.supabase.co', 'public',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
      httpClient: MockClient((request) async => http.Response(jsonEncode({
        'access_token': token, 'refresh_token': 'refresh', 'expires_in': 3600,
        'token_type': 'bearer',
        'user': {'id': 'guest', 'aud': 'authenticated', 'role': 'authenticated',
          'created_at': '2026-11-27T00:00:00Z', 'app_metadata': {}, 'user_metadata': {}},
      }), 200, headers: {'content-type': 'application/json'}, request: request)),
    );
    addTearDown(client.dispose);
    await client.auth.signInAnonymously();
    final sent = <Map<String, dynamic>>[];
    final api = KingApiService(supabase: client, httpClient: MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      sent.add(body);
      return http.Response(jsonEncode({'room': {'id': 'room', 'code': body['code']}}),
        200, headers: {'content-type': 'application/json'}, request: request);
    }));
    final controller = KingController(api: api);
    addTearDown(controller.dispose);
    expect(await controller.joinRoom(' aB7xQ2 '), isTrue);
    expect(await controller.joinRoom('ab7xq2'), isTrue);
    expect(await controller.joinRoom('king-abc'), isTrue);
    expect(sent.map((r) => r['code']), ['aB7xQ2', 'ab7xq2', 'KING-ABC']);
    expect(sent.map((r) => r['ownerToken']), ['mixed-token', 'lower-token', 'legacy-token']);
  });

  test('short codes preserve case while trimming surrounding whitespace', () {
    expect(normalizeInviteCode(' aB7xQ2 '), 'aB7xQ2');
    expect(normalizeInviteCode('ab7xq2'), isNot(normalizeInviteCode('aB7xQ2')));
  });

  test('legacy KING codes retain case-insensitive normalization', () {
    expect(normalizeInviteCode(' king-abc '), 'KING-ABC');
  });
}
