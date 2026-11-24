import "package:flutter/material.dart";

import "../../l10n/strings.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "waiting_screen.dart";

class RoomScreen extends StatefulWidget {
  const RoomScreen({required this.controller, super.key});

  final KingController controller;

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
    final l = context.strings;
    final controller = widget.controller;
    final progress = controller.submittedCount / controller.memberLimit;

    return RoyalScaffold(
      title: controller.groupName,
      kicker: l.royalCourt,
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
              Expanded(
                  child: Text(l.receiving,
                      style: Theme.of(context).textTheme.bodySmall)),
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
              color: KingColors.burgundyDark,
              border: Border.all(color: KingColors.gold),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Kicker(l.todayTopic, light: true),
                const SizedBox(height: 12),
                Text(
                  controller.topic,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: KingColors.paperLight,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 22),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: KingColors.paper.withValues(alpha: .19),
                  color: KingColors.goldLight,
                ),
                const SizedBox(height: 8),
                Text(
                  l.submittedCount(controller.submittedCount),
                  style: const TextStyle(
                    color: KingColors.paperDeep,
                    fontFamily: KingTheme.sans,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          InviteCodeTile(code: controller.roomCode),
          const SizedBox(height: 26),
          RoyalPanel(
            child: Column(
              children: [
                Text(l.petitionHeading,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                if (controller.hasSubmitted)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(l.movingToWaiting),
                  )
                else ...[
                  TextField(
                    controller: opinionController,
                    minLines: 5,
                    maxLines: 7,
                    maxLength: 300,
                    onChanged: controller.updateOpinion,
                    decoration: InputDecoration(
                      hintText: l.petitionHint,
                    ),
                  ),
                  const SizedBox(height: 5),
                  PrivacyNote(l.petitionLocked),
                  const SizedBox(height: 18),
                  RoyalButton(
                    label: controller.isRoomBusy ? l.sealing : l.submitPetition,
                    icon: Icons.edit_note,
                    onPressed: controller.opinion.trim().length >= 10 &&
                            !controller.isRoomBusy
                        ? controller.submitOpinion
                        : null,
                  ),
                  if (controller.roomError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l.errorMessage(controller.roomError!),
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
