import "package:flutter/foundation.dart";

import "../data/demo_data.dart";
import "../models/ai_verdict.dart";
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

  Future<void> refreshRoom() async {
    final id = roomId;
    if (id == null || isRoomBusy) return;
    try {
      _apply(await _api.getRoom(id));
    } on KingApiException catch (error) {
      roomError = error.message;
      notifyListeners();
    }
  }

  Future<void> submitOpinion() async {
    final id = roomId;
    if (id == null || opinion.trim().length < 10 || hasSubmitted || isRoomBusy) {
      return;
    }
    await _runRoomAction(() async {
      _apply(await _api.submitOpinion(id, opinion.trim()));
    });
  }

  Future<void> generateVerdict() async {
    final id = roomId;
    if (id == null || isGeneratingVerdict || verdict != null) return;
    isGeneratingVerdict = true;
    verdictError = null;
    notifyListeners();

    try {
      _apply(await _api.generateVerdict(id));
    } on KingApiException catch (error) {
      verdictError = error.message;
    } catch (_) {
      verdictError = "AI 평결을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.";
    } finally {
      isGeneratingVerdict = false;
      notifyListeners();
    }
  }

  Future<void> retryVerdict() async {
    verdict = null;
    await generateVerdict();
  }

  Future<void> saveDecision() async {
    final id = roomId;
    if (id == null || verdict == null || isSavingRecord || isRecordSaved) return;
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
