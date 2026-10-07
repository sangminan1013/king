import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({required this.controller, super.key});

  final KingController controller;

  @override
  Widget build(BuildContext context) {
    return RoyalScaffold(
      title: "최종 기록",
      kicker: "COUNCIL ARCHIVE",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 45, 24, 40),
        children: [
          const RoyalCrest(),
          const Kicker("DECISION RECORDED"),
          const SizedBox(height: 9),
          Text(
            controller.groupName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 5),
          Text(
            "참여자 ${controller.memberLimit}명",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 27),
          Container(
            padding: const EdgeInsets.all(21),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.28),
              border: Border.all(color: const Color(0xFFB7A280)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Kicker("결정 안건"),
                const SizedBox(height: 8),
                Text(controller.topic, style: Theme.of(context).textTheme.bodyMedium),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 17),
                  child: Divider(color: Color(0x337B6248), height: 1),
                ),
                const Kicker("최종 평결"),
                const SizedBox(height: 8),
                Text(
                  "도심 근교의 복합 문화 공간",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: KingColors.burgundyDark,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: KingColors.gold, width: 2)),
                  ),
                  child: Text(
                    "“접근성, 활동 선택권, 예산의 균형을 가장 잘 충족합니다.”",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RoyalButton(
            label: "기록 저장하기",
            icon: Icons.save_alt,
            style: RoyalButtonStyle.secondary,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("서버 연결 후 기록 저장 기능이 활성화됩니다.")),
            ),
          ),
          const SizedBox(height: 8),
          RoyalButton(
            label: "처음으로 돌아가기",
            icon: Icons.logout,
            style: RoyalButtonStyle.ghost,
            onPressed: () {
              controller.reset();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
