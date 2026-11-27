import "package:flutter/foundation.dart";

import "../data/demo_data.dart";
import "../models/ai_verdict.dart";
import "../models/king_personality.dart";
import "../models/room_list_entry.dart";
import "../services/king_api_service.dart";

class KingController extends ChangeNotifier {
  KingController({KingApiService? api}) : _api = api ?? KingApiService();

  final KingApiService _api;

  String groupName = DemoData.groupName;
  String topic = DemoData.topic;
  int memberLimit = 5;
  KingPersonality kingPersonality = KingPersonality.wise;
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
  DateTime? finalizedAt;
  bool isRoomBusy = false;
  List<String> opinions = const [];

  Future<List<RoomListEntry>> listMyRooms({int offset = 0}) =>
      _api.listMyRooms(offset: offset);

  Future<bool> openRoom(String id) => _runRoomAction(() async {
        final snapshot = await _api.getRoom(id);
        if (snapshot.status == "finalized" && snapshot.verdict == null) {
          throw const KingApiException("ui:verdictMissing");
        }
        opinion = "";
        verdictError = null;
        _apply(snapshot);
      });

  void updateGroupName(String value) {
    groupName = value;
    notifyListeners();
  }

  void selectKing(KingPersonality value) {
    if (isRoomBusy) return;
    kingPersonality = value;
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
        kingPersonality: kingPersonality.id,
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
        verdictError = "ui:verdictWait";
        return false;
      }
      if (verdict != null) return true;
      if (roomStatus == "finalized") {
        verdictError = "ui:verdictMissing";
        return false;
      }
      final generated = await _api.generateVerdict(id);
      if (roomId != id) return false;
      _apply(generated);
      if (verdict == null) {
        verdictError = "ui:verdictPending";
        return false;
      }
      return true;
    } on KingApiException catch (error) {
      verdictError = error.displayKey ?? error.message;
      return false;
    } catch (_) {
      verdictError = "ui:verdictError";
      return false;
    } finally {
      isGeneratingVerdict = false;
      notifyListeners();
    }
  }

  Future<bool> saveDecision() async {
    final id = roomId;
    if (isRecordSaved) return true;
    if (id == null || verdict == null || !isOwner || isSavingRecord) {
      return false;
    }
    roomError = null;
    isSavingRecord = true;
    notifyListeners();
    try {
      final snapshot = await _api.finalizeRoom(id);
      if (roomId != id) return false;
      _apply(snapshot);
      if (!isRecordSaved) {
        roomError = "ui:finalizeUnconfirmed";
      }
      return isRecordSaved;
    } on KingApiException catch (error) {
      roomError = error.displayKey ?? error.message;
      return false;
    } catch (_) {
      roomError = "ui:finalizeError";
      return false;
    } finally {
      isSavingRecord = false;
      notifyListeners();
    }
  }

  void startAnotherDecision() {
    kingPersonality = KingPersonality.wise;
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
    finalizedAt = null;
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
      roomError = error.displayKey ?? error.message;
      return false;
    } catch (_) {
      roomError = "ui:networkError";
      return false;
    } finally {
      isRoomBusy = false;
      notifyListeners();
    }
  }

  void _apply(RoomSnapshot snapshot) {
    kingPersonality = KingPersonality.fromId(snapshot.kingPersonality);
    finalizedAt = snapshot.finalizedAt;
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
