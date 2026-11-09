import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "create_room_screen.dart";
import "join_room_screen.dart";
import "room_history_screen.dart";
import "settings_screen.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.controller,
    required this.onSignOut,
    super.key,
  });

  final KingController controller;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    void open(Widget screen) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => screen));
    }

    return RoyalScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        children: [
          const SizedBox(height: 16),
          const RoyalCrest(),
          const SizedBox(height: 14),
          const Kicker("A FAIR DECISION, TOGETHER"),
          const SizedBox(height: 10),
          Text("King",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 20),
          Text(
            "모두의 목소리를 모아\n공정한 하나의 답으로",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF5C4F40),
                  height: 1.7,
                ),
          ),
          const SizedBox(height: 16),
          RoyalButton(
            label: "새로운 회의 열기",
            subtitle: "안건을 세우고 사람들을 초대하세요",
            icon: Icons.add,
            onPressed: () {
              controller.reset();
              open(CreateRoomScreen(controller: controller));
            },
          ),
          const SizedBox(height: 12),
          RoyalButton(
            label: "초대 코드로 입장",
            subtitle: "익명으로 의견을 보태세요",
            icon: Icons.meeting_room_outlined,
            style: RoyalButtonStyle.secondary,
            onPressed: () {
              controller.reset();
              open(JoinRoomScreen(controller: controller));
            },
          ),
          const SizedBox(height: 12),
          RoyalButton(
            label: "회의 기록",
            subtitle: "참여한 회의와 이전 결정을 다시 확인하세요",
            icon: Icons.history,
            style: RoyalButtonStyle.secondary,
            onPressed: () => open(RoomHistoryScreen(controller: controller)),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => open(SettingsScreen(onSignOut: onSignOut)),
            icon: const Icon(Icons.settings_outlined, size: 18),
            label: const Text("환경 설정"),
            style: TextButton.styleFrom(foregroundColor: KingColors.muted),
          ),
          const SizedBox(height: 15),
          const PrivacyNote("이름 없이, 편견 없이. 함께 결정하는 공간입니다."),
        ],
      ),
    );
  }
}
