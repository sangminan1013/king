import "package:flutter/foundation.dart";

class KingController extends ChangeNotifier {
  String groupName = "금요일 원정대";
  String topic = "이번 분기 팀 워크숍 장소는 어디가 좋을까요?";
  int memberLimit = 5;
  int submittedCount = 3;
  String opinion = "";
  bool hasSubmitted = false;

  static const String roomCode = "CROWN-27";

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

  void submitOpinion() {
    if (opinion.trim().length < 10 || hasSubmitted) return;
    hasSubmitted = true;
    submittedCount = (submittedCount + 1).clamp(0, memberLimit).toInt();
    notifyListeners();
  }

  void startAnotherDecision() {
    topic = "";
    opinion = "";
    hasSubmitted = false;
    submittedCount = 1;
    notifyListeners();
  }

  void reset() {
    groupName = "금요일 원정대";
    topic = "이번 분기 팀 워크숍 장소는 어디가 좋을까요?";
    memberLimit = 5;
    submittedCount = 3;
    opinion = "";
    hasSubmitted = false;
    notifyListeners();
  }
}
