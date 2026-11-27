import "package:flutter/material.dart";

import "../../l10n/strings.dart";

import "../controller/king_controller.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "result_screen.dart";
import "summary_screen.dart";

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  bool checking = false;
  bool leaving = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) checkStatus();
    });
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    super.dispose();
  }

  Future<void> checkStatus() async {
    if (checking || leaving) return;
    setState(() => checking = true);
    final controller = widget.controller;
    try {
      final refreshed = await controller.refreshRoom();
      if (!mounted || ModalRoute.of(context)?.isCurrent != true || !refreshed) {
        return;
      }
      if (controller.roomStatus == "finalized" && controller.verdict != null) {
        showResult(archived: true);
      } else if (controller.hasSubmitted && controller.allOpinionsSubmitted) {
        final ready = await controller.generateVerdict();
        if (mounted && ready && ModalRoute.of(context)?.isCurrent == true) {
          showResult(archived: controller.roomStatus == "finalized");
        }
      }
    } finally {
      if (mounted) setState(() => checking = false);
    }
  }

  void showResult({required bool archived}) {
    if (leaving) return;
    leaving = true;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (_) => archived
          ? SummaryScreen(controller: widget.controller)
          : ResultScreen(controller: widget.controller),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    final controller = widget.controller;
    final error = controller.roomError ?? controller.verdictError;
    return RoyalScaffold(
      title: l.deliberation,
      kicker:
          "${l.profile(controller.kingPersonality).name} · ${controller.roomCode}",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
        children: [
          const RoyalCrest(),
          const SizedBox(height: 20),
          Text(
            controller.isGeneratingVerdict ? l.deliberating : l.sealed,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(controller.topic, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text(
            l.submissionStatus(
                controller.submittedCount, controller.memberLimit),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: controller.memberLimit > 0
                ? (controller.submittedCount / controller.memberLimit)
                    .clamp(0, 1)
                    .toDouble()
                : 0,
            color: KingColors.burgundy,
          ),
          const SizedBox(height: 16),
          Text(
            controller.allOpinionsSubmitted
                ? l.allSubmitted
                : l.waitingMembers(controller.memberLimit),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (checking) const Center(child: CircularProgressIndicator()),
          if (error != null && !checking) ...[
            Text(l.errorMessage(error),
                textAlign: TextAlign.center,
                style: const TextStyle(color: KingColors.burgundy)),
            const SizedBox(height: 12),
          ],
          RoyalButton(
            label: checking ? l.checking : l.checkStatus,
            icon: Icons.refresh,
            onPressed: checking || leaving ? null : checkStatus,
          ),
          const SizedBox(height: 12),
          Text(
            l.checkHelp,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          InviteCodeTile(code: controller.roomCode),
          if (controller.hasSubmitted &&
              controller.opinion.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            RoyalPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Kicker(l.yourPetition),
                  const SizedBox(height: 8),
                  SelectableText(controller.opinion.trim()),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
