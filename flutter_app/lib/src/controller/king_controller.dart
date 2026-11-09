import "package:flutter/foundation.dart";

import "../data/demo_data.dart";
import "../models/ai_verdict.dart";
import "../models/room_list_entry.dart";
import "../services/king_api_service.dart";

class KingController extends ChangeNotifier {
  KingController({KingApiService? api}) : _api = api ?? KingApiService();

  final KingApiService _api;

  String groupName = DemoData.groupName;
  String topic = DemoData.topic;
  int memberLimit = 5;
  int memberCount = 0;
  int submittedCount = 0;
  String opinion = "";
  String? roomId;
  String roomCode = "";
  String roomStatus = "collecting";
  bool isOwner = false;
  bool hasSubmitted = false;
  AiVerdict? verdict;
  String? verdictError;
  String? roomError;
  bool isGeneratingVerdict = false;
  bool isSavingRecord = false;
  bool isRecordSaved = false;
  bool isRoomBusy = false;
  List<String> opinions = const [];

  Future<List<RoomListEntry>> listMyRooms({int offset = 0}) =>
      _api.listMyRooms(offset: offset);

  Future<bool> openRoom(String id) => _runRoomAction(() async {
        final snapshot = await _api.getRoom(id);
        if (snapshot.status == "finalized" && snapshot.verdict == null) {
          throw const KingApiException("저장된 평결을 찾지 못했습니다.");
        }
        opinion = "";
        verdictError = null;
        _apply(snapshot);
      });

  void updateGroupName(String value) {
    groupName = value;
    notifyListeners();
  }

  void updateTopic(String value) {
    topic = value;
    notifyListeners();
  }

  void changeMemberLimit(int delta) {
    memberLimit = (memberLimit + delta).clamp(2, 12).toInt();
    notifyListeners();
  }

  void updateOpinion(String value) {
    opinion = value;
    notifyListeners();
  }

  Future<bool> createRoom() async {
    return _runRoomAction(() async {
      final snapshot = await _api.createRoom(
        groupName: groupName,
        topic: topic,
        memberLimit: memberLimit,
      );
      _apply(snapshot);
    });
  }

  Future<bool> joinRoom(String code) async {
    return _runRoomAction(() async {
      _apply(await _api.joinRoom(code.trim().toUpperCase()));
    });
  }

  bool get allOpinionsSubmitted =>
      memberLimit >= 2 &&
      memberCount == memberLimit &&
      submittedCount == memberLimit;

  Future<bool> refreshRoom() async {
    final id = roomId;
    if (id == null) return false;
    return _runRoomAction(() async {
      final snapshot = await _api.getRoom(id);
      if (roomId == id) _apply(snapshot);
    });
  }

  Future<void> submitOpinion() async {
    final id = roomId;
    if (id == null ||
        opinion.trim().length < 10 ||
        hasSubmitted ||
        isRoomBusy) {
      return;
    }
    await _runRoomAction(() async {
      _apply(await _api.submitOpinion(id, opinion.trim()));
    });
  }

  Future<bool> generateVerdict() async {
    final id = roomId;
    if (id == null || isGeneratingVerdict) return false;
    isGeneratingVerdict = true;
    verdictError = null;
    notifyListeners();
    try {
      // Always confirm readiness against the server, even if a caller bypasses
      // the waiting screen or the last local snapshot is out of date.
      final snapshot = await _api.getRoom(id);
      if (roomId != id) return false;
      _apply(snapshot);
      if (roomStatus != "finalized" && !allOpinionsSubmitted) {
        verdictError = "설정한 참여 인원 모두가 제출할 때까지 기다려 주세요.";
        return false;
      }
      if (verdict != null) return true;
      if (roomStatus == "finalized") {
        verdictError = "저장된 평결을 찾지 못했습니다.";
        return false;
      }
      final generated = await _api.generateVerdict(id);
      if (roomId != id) return false;
      _apply(generated);
      if (verdict == null) {
        verdictError = "평결이 아직 준비되지 않았습니다. 다시 확인해 주세요.";
        return false;
      }
      return true;
    } on KingApiException catch (error) {
      verdictError = error.message;
      return false;
    } catch (_) {
      verdictError = "AI 평결을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.";
      return false;
    } finally {
      isGeneratingVerdict = false;
      notifyListeners();
    }
  }

  Future<void> saveDecision() async {
    final id = roomId;
    if (id == null || verdict == null || isSavingRecord || isRecordSaved) {
      return;
    }
    isSavingRecord = true;
    notifyListeners();
    try {
      _apply(await _api.finalizeRoom(id));
      isRecordSaved = true;
    } on KingApiException catch (error) {
      roomError = error.message;
    } finally {
      isSavingRecord = false;
      notifyListeners();
    }
  }

  void startAnotherDecision() {
    topic = "";
    opinion = "";
    roomId = null;
    roomCode = "";
    roomStatus = "collecting";
    memberCount = 0;
    submittedCount = 0;
    hasSubmitted = false;
    isOwner = false;
    verdict = null;
    verdictError = null;
    roomError = null;
    isRecordSaved = false;
    opinions = const [];
    notifyListeners();
  }

  void reset() {
    groupName = DemoData.groupName;
    topic = DemoData.topic;
    memberLimit = 5;
    startAnotherDecision();
  }

  Future<bool> _runRoomAction(Future<void> Function() action) async {
    if (isRoomBusy) return false;
    isRoomBusy = true;
    roomError = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on KingApiException catch (error) {
      roomError = error.message;
      return false;
    } catch (_) {
      roomError = "서버에 연결하지 못했습니다. 네트워크 상태를 확인해 주세요.";
      return false;
    } finally {
      isRoomBusy = false;
      notifyListeners();
    }
  }

  void _apply(RoomSnapshot snapshot) {
    roomId = snapshot.id;
    roomCode = snapshot.code;
    groupName = snapshot.groupName;
    topic = snapshot.topic;
    memberLimit = snapshot.memberLimit;
    memberCount = snapshot.memberCount;
    submittedCount = snapshot.submittedCount;
    roomStatus = snapshot.status;
    isOwner = snapshot.isOwner;
    hasSubmitted = snapshot.hasSubmitted;
    verdict = snapshot.verdict;
    opinions = snapshot.opinions;
    isRecordSaved = snapshot.status == "finalized";
  }
}
