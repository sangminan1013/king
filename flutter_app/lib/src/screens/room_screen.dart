import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "result_screen.dart";

class RoomScreen extends StatefulWidget {
  const RoomScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late final TextEditingController opinionController;

  @override
  void initState() {
    super.initState();
    opinionController = TextEditingController(text: widget.controller.opinion);
    widget.controller.addListener(refresh);
  }

  void refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    opinionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final progress = controller.submittedCount / controller.memberLimit;

    return RoyalScaffold(
      title: controller.groupName,
      kicker: "ROOM · ${KingController.roomCode}",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: KingColors.green,
                ),
              ),
              const SizedBox(width: 7),
              Text("의견 수집 중", style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              const Icon(Icons.people_outline, size: 17, color: KingColors.muted),
              const SizedBox(width: 5),
              Text(
                "${controller.submittedCount} / ${controller.memberLimit}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(21, 23, 21, 18),
            decoration: BoxDecoration(
              color: KingColors.burgundyDark,
              border: Border.all(color: KingColors.gold),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Kicker("TODAY'S DECISION", light: true),
                const SizedBox(height: 12),
                Text(
                  controller.topic,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFFFFF5DF),
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 22),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Colors.white.withOpacity(.15),
                  color: KingColors.goldLight,
                ),
                const SizedBox(height: 8),
                Text(
                  "${controller.submittedCount}명이 의견을 제출했습니다",
                  style: const TextStyle(
                    color: Color(0xFFD4C2A1),
                    fontFamily: "sans-serif",
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          const InviteCodeTile(code: KingController.roomCode),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.22),
              border: Border.all(color: const Color(0x337B6248)),
            ),
            child: Column(
              children: [
                const ChapterTitle(
                  number: "II",
                  chapter: "두 번째 장",
                  title: "당신의 조건을 들려주세요",
                ),
                const SizedBox(height: 24),
                if (controller.hasSubmitted)
                  _SubmittedState(controller: controller)
                else ...[
                  TextField(
                    controller: opinionController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 300,
                    onChanged: controller.updateOpinion,
                    decoration: const InputDecoration(
                      hintText: "중요하게 생각하는 조건, 피하고 싶은 선택,\n원하는 결과를 자유롭게 적어주세요.",
                    ),
                  ),
                  const SizedBox(height: 5),
                  const PrivacyNote("제출 후에는 수정할 수 없으며 익명으로 처리됩니다."),
                  const SizedBox(height: 18),
                  RoyalButton(
                    label: "의견 봉인하기",
                    icon: Icons.edit_note,
                    onPressed: controller.opinion.trim().length >= 10
                        ? controller.submitOpinion
                        : null,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmittedState extends StatelessWidget {
  const _SubmittedState({required this.controller});

  final KingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: const BoxDecoration(
            color: KingColors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Color(0xFFFFF5DF), size: 30),
        ),
        const SizedBox(height: 14),
        Text("의견이 봉인되었습니다", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 7),
        Text(
          "다른 참여자의 제출을 기다리고 있습니다.\n내용은 누구에게도 표시되지 않습니다.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 22),
        RoyalButton(
          label: "AI 평결 미리보기",
          icon: Icons.auto_awesome_outlined,
          style: RoyalButtonStyle.secondary,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ResultScreen(controller: controller),
            ),
          ),
        ),
      ],
    );
  }
}
