import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'room.dart';

abstract class RoomRepository {
  Future<Room> create(String name, String topic, int capacity);
  Future<Room> get(String code);
  Future<Room> act(
    String code,
    String action, [
    Map<String, dynamic> input = const {},
  ]);
  void dispose() {}
}

class RoomException implements Exception {
  final String message;
  RoomException(this.message);
  @override
  String toString() => message;
}

// 화면은 이 인터페이스로 서버에 접근합니다. DB와 LLM에는 직접 연결하지 않습니다.
class HttpRoomRepository extends RoomRepository {
  final String baseUrl;
  final HttpClient _client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10);
  HttpRoomRepository(String url) : baseUrl = url.replaceAll(RegExp(r'/+$'), '');
  Future<Room> _request(
    String method,
    String path, [
    Map<String, dynamic>? input,
  ]) async {
    HttpClientRequest? request;
    try {
      return await (() async {
        request = await _client.openUrl(method, Uri.parse('$baseUrl$path'));
        request!.headers.contentType = ContentType.json;
        if (input != null) request!.write(jsonEncode(input));
        final response = await request!.close();
        final data = jsonDecode(
          await response.transform(utf8.decoder).join(),
        ) as Map<String, dynamic>;
        if (response.statusCode >= 400) {
          throw RoomException(data['error'] ?? '요청에 실패했습니다.');
        }
        return Room.fromJson(data);
      })().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          request?.abort();
          throw RoomException('서버 응답 시간이 초과되었습니다. 새로고침으로 상태를 확인해주세요.');
        },
      );
    } on RoomException {
      rethrow;
    } catch (_) {
      throw RoomException('서버 연결을 확인해주세요. API_BASE_URL과 서버 실행 상태를 확인하세요.');
    }
  }

  @override
  Future<Room> create(String name, String topic, int capacity) => _request(
    'POST',
    '/rooms',
    {'name': name, 'topic': topic, 'capacity': capacity},
  );
  @override
  Future<Room> get(String code) =>
      _request('GET', '/rooms/${Uri.encodeComponent(code.toUpperCase())}');
  @override
  Future<Room> act(
    String code,
    String action, [
    Map<String, dynamic> input = const {},
  ]) => _request('POST', '/rooms/${Uri.encodeComponent(code)}/$action', input);
  @override
  void dispose() => _client.close(force: true);
}

// 서버 없이 실행하는 데모 저장소. 앱 종료 시 데이터가 사라집니다.
class DemoRoomRepository extends RoomRepository {
  final Map<String, Room> _rooms = {};
  final Random _random = Random.secure();
  @override
  Future<Room> create(String name, String topic, int capacity) async {
    if (name.trim().isEmpty ||
        topic.trim().isEmpty ||
        capacity < 2 ||
        capacity > 20) {
      throw RoomException('그룹 이름, 주제, 인원수를 확인해주세요.');
    }
    String code;
    do {
      code = List.generate(
        6,
        (_) => '0123456789ABCDEF'[_random.nextInt(16)],
      ).join();
    } while (_rooms.containsKey(code));
    return _rooms[code] = Room(
      code: code,
      name: name.trim(),
      topic: topic.trim(),
      capacity: capacity,
    );
  }

  @override
  Future<Room> get(String code) async {
    final room = _rooms[code.toUpperCase()];
    if (room == null) {
      throw RoomException('방을 찾을 수 없습니다. 데모에서는 이 앱에서 만든 방만 입장할 수 있습니다.');
    }
    return room;
  }

  @override
  Future<Room> act(
    String code,
    String action, [
    Map<String, dynamic> input = const {},
  ]) async {
    final room = await get(code);
    if (room.closed) throw RoomException('종료된 방입니다.');
    switch (action) {
      case 'opinions':
        if (room.result != null) throw RoomException('다음 안건을 시작해주세요.');
        if (room.opinions.length >= room.capacity) {
          throw RoomException('설정한 인원수만큼 의견이 모였습니다.');
        }
        final author = (input['author'] as String? ?? '').trim();
        final condition = (input['condition'] as String? ?? '').trim();
        final text = (input['text'] as String? ?? '').trim();
        if (author.isEmpty || condition.isEmpty || text.isEmpty) {
          throw RoomException('모든 입력란을 채워주세요.');
        }
        if (room.opinions.any((o) => o.author == author)) {
          throw RoomException('이 안건에 이미 의견을 제출한 이름입니다.');
        }
        room.opinions.add(Opinion(author, condition, text));
      case 'result':
        if (room.opinions.isEmpty) throw RoomException('먼저 의견을 입력해주세요.');
        room.result ??=
            '임시 결과 · 실제 AI 분석이 아닙니다.\n\n주제: ${room.topic}\n수집된 의견: ${room.opinions.length}개\n\n${room.opinions.map((o) => '${o.author}\n조건: ${o.condition}\n의견: ${o.text}').join('\n\n')}';
      case 'next':
        if (room.result == null) throw RoomException('현재 안건의 결과를 먼저 확인해주세요.');
        room.history.add(RoundResult(room.round, room.result!));
        room.round++;
        room.opinions.clear();
        room.result = null;
      case 'finish':
        if (room.result == null) throw RoomException('현재 안건의 결과를 먼저 확인해주세요.');
        room.history.add(RoundResult(room.round, room.result!));
        room.closed = true;
      default:
        throw RoomException('지원하지 않는 요청입니다.');
    }
    return room;
  }
}
