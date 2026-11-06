import "dart:convert";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;
import "package:supabase_flutter/supabase_flutter.dart";

import "../config/supabase_config.dart";
import "../models/ai_verdict.dart";

class RoomSnapshot {
  const RoomSnapshot({
    required this.id,
    required this.code,
    required this.groupName,
    required this.topic,
    required this.memberLimit,
    required this.memberCount,
    required this.submittedCount,
    required this.status,
    required this.isOwner,
    required this.hasSubmitted,
    required this.opinions,
    this.verdict,
  });

  final String id;
  final String code;
  final String groupName;
  final String topic;
  final int memberLimit;
  final int memberCount;
  final int submittedCount;
  final String status;
  final bool isOwner;
  final bool hasSubmitted;
  final List<String> opinions;
  final AiVerdict? verdict;

  factory RoomSnapshot.fromJson(Map<String, dynamic> json) {
    final rawOpinions = json["opinions"];
    final rawVerdict = json["verdict"];
    return RoomSnapshot(
      id: json["id"]?.toString() ?? "",
      code: json["code"]?.toString() ?? "",
      groupName: json["groupName"]?.toString() ?? "",
      topic: json["topic"]?.toString() ?? "",
      memberLimit: (json["memberLimit"] as num?)?.toInt() ?? 2,
      memberCount: (json["memberCount"] as num?)?.toInt() ?? 0,
      submittedCount: (json["submittedCount"] as num?)?.toInt() ?? 0,
      status: json["status"]?.toString() ?? "collecting",
      isOwner: json["isOwner"] == true,
      hasSubmitted: json["hasSubmitted"] == true,
      opinions: rawOpinions is List
          ? rawOpinions.map((value) => value.toString()).toList()
          : const [],
      verdict: rawVerdict is Map<String, dynamic>
          ? AiVerdict.fromJson(rawVerdict)
          : null,
    );
  }
}

class KingApiService {
  KingApiService({
    SupabaseClient? supabase,
    http.Client? httpClient,
    FlutterSecureStorage? secureStorage,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _http = httpClient ?? http.Client(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final SupabaseClient _supabase;
  final http.Client _http;
  final FlutterSecureStorage _secureStorage;

  String _ownerTokenKey(String code) =>
      "king.room-owner.${code.trim().toUpperCase()}";

  Future<RoomSnapshot> createRoom({
    required String groupName,
    required String topic,
    required int memberLimit,
  }) {
    return _roomRequest(
      "POST",
      "/rooms",
      body: {
        "groupName": groupName,
        "topic": topic,
        "memberLimit": memberLimit,
      },
    );
  }

  Future<RoomSnapshot> joinRoom(String code) async {
    final normalizedCode = code.trim().toUpperCase();
    final ownerToken = await _secureStorage.read(
      key: _ownerTokenKey(normalizedCode),
    );
    return _roomRequest(
      "POST",
      "/rooms/join",
      body: {
        "code": normalizedCode,
        if (ownerToken != null) "ownerToken": ownerToken,
      },
    );
  }

  Future<RoomSnapshot> getRoom(String roomId) =>
      _roomRequest("GET", "/rooms/$roomId");

  Future<RoomSnapshot> submitOpinion(String roomId, String content) =>
      _roomRequest(
        "POST",
        "/rooms/$roomId/opinions",
        body: {"content": content},
      );

  Future<RoomSnapshot> generateVerdict(String roomId) =>
      _roomRequest("POST", "/rooms/$roomId/verdict");

  Future<RoomSnapshot> finalizeRoom(String roomId) =>
      _roomRequest("POST", "/rooms/$roomId/finalize");

  Future<RoomSnapshot> _roomRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw const KingApiException("게스트 세션이 만료되었습니다. 다시 입장해 주세요.");
    }

    final request = http.Request(
      method,
      Uri.parse("${SupabaseConfig.functionBaseUrl}$path"),
    )
      ..headers.addAll({
        "apikey": SupabaseConfig.anonKey,
        "Authorization": "Bearer ${session.accessToken}",
        "Content-Type": "application/json",
      });
    if (body != null) request.body = jsonEncode(body);

    final streamed = await _http.send(request);
    final response = await http.Response.fromStream(streamed);
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded["error"];
      final message = error is Map<String, dynamic>
          ? error["message"]?.toString()
          : null;
      throw KingApiException(message ?? "서버 요청에 실패했습니다.");
    }

    final room = decoded["room"];
    if (room is! Map<String, dynamic>) {
      throw const KingApiException("서버 응답을 읽지 못했습니다.");
    }
    final snapshot = RoomSnapshot.fromJson(room);
    final ownerToken = decoded["ownerToken"];
    if (ownerToken is String && ownerToken.isNotEmpty) {
      await _secureStorage.write(
        key: _ownerTokenKey(snapshot.code),
        value: ownerToken,
      );
    }
    return snapshot;
  }
}

class KingApiException implements Exception {
  const KingApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
