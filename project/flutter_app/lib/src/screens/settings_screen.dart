import "package:flutter/material.dart";

import "../widgets/royal_widgets.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoyalScaffold(
      title: "환경 설정",
      kicker: "PREFERENCES",
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 65, 24, 40),
        child: Column(
          children: [
            const RoyalCrest(),
            const SizedBox(height: 14),
            Text("곧 준비될 예정입니다", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              "알림, 언어, AI 평결 방식과\n개인정보 설정이 이곳에 추가됩니다.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 30),
            RoyalButton(
              label: "첫 화면으로",
              style: RoyalButtonStyle.secondary,
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }
}
