import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "room_screen.dart";

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return RoyalScaffold(
      title: "회의 입장",
      kicker: "ENTER THE CHAMBER",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 65, 24, 40),
        children: [
          const RoyalCrest(),
          const SizedBox(height: 10),
          Text(
            "초대장을 확인합니다",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            "방장이 공유한 8자리 코드를 입력하세요.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 35),
          Text("초대 코드", style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            autofocus: true,
            maxLength: 8,
            textCapitalization: TextCapitalization.characters,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: KingColors.burgundyDark,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(hintText: "CROWN-27"),
            onChanged: (value) => setState(() => code = value),
          ),
          const SizedBox(height: 18),
          RoyalButton(
            label: "회의실 문 열기",
            onPressed: code.trim().length >= 6
                ? () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RoomScreen(controller: widget.controller),
                      ),
                    )
                : null,
          ),
          const SizedBox(height: 24),
          const PrivacyNote("별도의 이름이나 계정 정보는 표시되지 않습니다."),
        ],
      ),
    );
  }
}
