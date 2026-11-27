import "package:flutter/material.dart";

import "../../l10n/strings.dart";

import "../controller/king_controller.dart";
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
    final l = context.strings;
    void open(Widget screen) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => screen));
    }

    return RoyalScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
        children: [
          const CourtHero(),
          const SizedBox(height: 26),
          RoyalButton(
            label: l.convene,
            subtitle: l.conveneDescription,
            icon: Icons.add,
            onPressed: () {
              controller.reset();
              open(CreateRoomScreen(controller: controller));
            },
          ),
          const SizedBox(height: 12),
          RoyalButton(
            label: l.enterCourt,
            subtitle: l.enterDescription,
            icon: Icons.meeting_room_outlined,
            style: RoyalButtonStyle.secondary,
            onPressed: () {
              controller.reset();
              open(JoinRoomScreen(controller: controller));
            },
          ),
          const SizedBox(height: 12),
          RoyalButton(
            label: l.history,
            subtitle: l.historyDescription,
            icon: Icons.history,
            style: RoyalButtonStyle.secondary,
            onPressed: () => open(RoomHistoryScreen(controller: controller)),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => open(SettingsScreen(onSignOut: onSignOut)),
            icon: const Icon(Icons.settings_outlined, size: 18),
            label: Text(l.courtSettings),
          ),
        ],
      ),
    );
  }
}
