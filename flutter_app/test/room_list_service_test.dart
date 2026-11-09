import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:king/src/services/king_api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const userId = '11111111-1111-4111-8111-111111111111';

  test('room list requires a session before querying any data', () async {
    var requests = 0;
    final client = SupabaseClient(
      'https://example.supabase.co',
      'public-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
      httpClient: MockClient((request) async {
        requests++;
        return http.Response('[]', 200);
      }),
    );
    addTearDown(client.dispose);
    await expectLater(KingApiService(supabase: client).listMyRooms(),
        throwsA(isA<KingApiException>()));
    expect(requests, 0);
  });

  test(
      'room list sends guest JWT, filters membership and paginates deterministically',
      () async {
    http.Request? roomRequest;
    final token = 'e30.${base64Url.encode(utf8.encode(jsonEncode({
              'sub': userId,
              'exp': DateTime.now()
                      .add(const Duration(hours: 1))
                      .millisecondsSinceEpoch ~/
                  1000,
            }))).replaceAll('=', '')}.signature';
    final client = SupabaseClient(
      'https://example.supabase.co',
      'public-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
      httpClient: MockClient((request) async {
        if (request.url.path == '/auth/v1/signup') {
          return http.Response(
              jsonEncode({
                'access_token': token,
                'refresh_token': 'test-refresh',
                'token_type': 'bearer',
                'expires_in': 3600,
                'user': {
                  'id': userId,
                  'aud': 'authenticated',
                  'role': 'authenticated',
                  'created_at': '2026-11-09T00:00:00Z',
                  'is_anonymous': true,
                  'app_metadata': <String, dynamic>{},
                  'user_metadata': <String, dynamic>{},
                },
              }),
              200,
              headers: {'content-type': 'application/json'}, request: request);
        }
        roomRequest = request;
        return http.Response(
            jsonEncode([
              {
                'id': 'room-id',
                'invite_code': 'KING-ABC',
                'group_name': '내 회의',
                'topic': '테스트 안건',
                'status': 'finalized',
                'owner_id': userId,
                'created_at': '2026-11-08T00:00:00Z',
                'finalized_at': '2026-11-09T00:00:00Z',
                'room_members': [
                  {'user_id': userId}
                ],
              }
            ]),
            200,
            headers: {'content-type': 'application/json'}, request: request);
      }),
    );
    addTearDown(client.dispose);
    await client.auth.signInAnonymously();
    final rooms =
        await KingApiService(supabase: client).listMyRooms(offset: 20);
    expect(roomRequest!.url.path, '/rest/v1/rooms');
    expect(roomRequest!.headers['Authorization'], 'Bearer $token');
    final query = roomRequest!.url.queryParameters;
    expect(query['select'], contains('room_members!inner(user_id)'));
    expect(query['room_members.user_id'], 'eq.$userId');
    expect(query['order']!.split(',')[0], startsWith('created_at.desc'));
    expect(query['order']!.split(',')[1], startsWith('id.desc'));
    expect(query['offset'], '20');
    expect(query['limit'], '20');
    expect(rooms.single.isOwner, isTrue);
    expect(rooms.single.isFinalized, isTrue);
    expect(rooms.single.finalizedAt, DateTime.utc(2026, 11, 9));
  });
}
