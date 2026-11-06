import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(refresh);
  }

  void refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final verdict = controller.verdict!;
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
                  verdict.title,
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
                    "“${verdict.summary}”",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          RoyalButton(
            label: controller.isRecordSaved
                ? "기록이 저장되었습니다"
                : controller.isSavingRecord
                    ? "저장하는 중..."
                    : "기록 저장하기",
            icon: controller.isRecordSaved ? Icons.check : Icons.save_alt,
            style: RoyalButtonStyle.secondary,
            onPressed: controller.isRecordSaved || controller.isSavingRecord
                ? null
                : () async {
                    await controller.saveDecision();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          controller.isRecordSaved
                              ? "Supabase에 최종 기록을 저장했습니다."
                              : controller.roomError ?? "기록을 저장하지 못했습니다.",
                        ),
                      ),
                    );
                  },
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
