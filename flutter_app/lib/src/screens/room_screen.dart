import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "waiting_screen.dart";
import "../theme/king_persona.dart";
import "../widgets/korean_ornaments.dart";

class RoomScreen extends StatefulWidget {
  const RoomScreen(
      {required this.controller, this.persona = KingPersona.wise, super.key});

  final KingController controller;
  final KingPersona persona;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late final TextEditingController opinionController;
  bool leaving = false;

  @override
  void initState() {
    super.initState();
    opinionController = TextEditingController(text: widget.controller.opinion);
    widget.controller.addListener(refresh);
    if (widget.controller.hasSubmitted) {
      goToWaitingIfSubmitted();
    } else {
      // Refresh notifies screens retained below this route too. Wait until
      // route construction finishes before updating their shared controller.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.controller.refreshRoom();
      });
    }
  }

  void refresh() {
    setState(() {});
    goToWaitingIfSubmitted();
  }

  void goToWaitingIfSubmitted() {
    if (!widget.controller.hasSubmitted || leaving) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || leaving || ModalRoute.of(context)?.isCurrent != true) {
        return;
      }
      if (!widget.controller.hasSubmitted) return;
      leaving = true;
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
        builder: (_) => WaitingScreen(controller: widget.controller),
      ));
    });
  }

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
      kicker: "ROOM · ${controller.roomCode}",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 40),
        children: [
          PersonaBanner(persona: widget.persona),
          const SizedBox(height: 20),
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
              const Icon(Icons.people_outline,
                  size: 17, color: KingColors.muted),
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
              color: widget.persona.color,
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
          InviteCodeTile(code: controller.roomCode),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: widget.persona.paper,
              border: Border.all(color: const Color(0x337B6248)),
            ),
            child: Column(
              children: [
                PersonaWritingHeading(persona: widget.persona),
                const SizedBox(height: 24),
                if (controller.hasSubmitted)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("대기 화면으로 이동합니다..."),
                  )
                else ...[
                  TextField(
                    controller: opinionController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 300,
                    onChanged: controller.updateOpinion,
                    decoration: InputDecoration(
                      hintText: widget.persona.hint,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const PrivacyNote("제출 후에는 수정할 수 없으며 익명으로 처리됩니다."),
                  const SizedBox(height: 18),
                  RoyalButton(
                    label: controller.isRoomBusy ? "의견을 봉인하는 중..." : "의견 봉인하기",
                    icon: Icons.edit_note,
                    onPressed: controller.opinion.trim().length >= 10 &&
                            !controller.isRoomBusy
                        ? controller.submitOpinion
                        : null,
                  ),
                  if (controller.roomError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      controller.roomError!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: KingColors.burgundy,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
