import "package:flutter/material.dart";

import "../../l10n/strings.dart";

import "../controller/king_controller.dart";
import "../models/ai_verdict.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "create_room_screen.dart";
import "summary_screen.dart";

class ResultScreen extends StatefulWidget {
  const ResultScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
    final l = context.strings;
    final controller = widget.controller;
    return RoyalScaffold(
      title: l.verdict,
      child: controller.verdict == null
          ? _VerdictError(
              message: l.verdictUnavailable,
              onRetry: () => Navigator.of(context).maybePop(),
            )
          : _VerdictContent(
              controller: controller, verdict: controller.verdict!),
    );
  }
}

class _VerdictError extends StatelessWidget {
  const _VerdictError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: KingColors.burgundy, size: 42),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 22),
            RoyalButton(
              label: l.back,
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerdictContent extends StatelessWidget {
  const _VerdictContent({required this.controller, required this.verdict});

  final KingController controller;
  final AiVerdict verdict;

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
      children: [
        RoyalPanel(
          style: RoyalPanelStyle.decree,
          child: Column(
            children: [
              const RoyalCrest(small: true),
              const SizedBox(height: 10),
              Kicker(l.profile(controller.kingPersonality).name),
              const SizedBox(height: 9),
              Text(verdict.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text(verdict.summary,
                  textAlign: TextAlign.center,
                  style: KingTheme.decisionSummary),
            ],
          ),
        ),
        const SizedBox(height: 20),
        RoyalPanel(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: KingColors.burgundyDark,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.verdictReasons,
                        style: const TextStyle(
                          color: KingColors.paperLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                        child: Text(
                      l.fitScore(verdict.fitScore),
                      style: const TextStyle(
                        color: KingColors.goldLight,
                        fontFamily: KingTheme.sans,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
                  ],
                ),
              ),
              for (final reason in verdict.reasons)
                _Reason(title: reason.title, detail: reason.detail),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: RoyalButton(
                label: l.newDecision,
                style: RoyalButtonStyle.secondary,
                onPressed: controller.isSavingRecord
                    ? null
                    : () {
                        controller.startAnotherDecision();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                CreateRoomScreen(controller: controller),
                          ),
                          (route) => route.isFirst,
                        );
                      },
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: RoyalButton(
                label: controller.isRecordSaved
                    ? l.viewRecord
                    : controller.isSavingRecord
                        ? l.finalizing
                        : l.finalize,
                onPressed: controller.isSavingRecord ||
                        (!controller.isOwner && !controller.isRecordSaved)
                    ? null
                    : () async {
                        final confirmed = await controller.saveDecision();
                        if (!context.mounted) return;
                        if (!confirmed) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(l.errorMessage(
                                  controller.roomError ?? l.finalizeError))));
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) =>
                                SummaryScreen(controller: controller)));
                      },
              ),
            ),
          ],
        ),
        if (!controller.isOwner && !controller.isRecordSaved) ...[
          const SizedBox(height: 12),
          Text(l.waitingHost, textAlign: TextAlign.center),
          RoyalButton(
              label: l.checkFinalization,
              style: RoyalButtonStyle.ghost,
              onPressed: controller.isRoomBusy
                  ? null
                  : () async {
                      await controller.refreshRoom();
                      if (!context.mounted) return;
                      if (controller.isRecordSaved) {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) =>
                                SummaryScreen(controller: controller)));
                      }
                    }),
        ],
        const SizedBox(height: 18),
        Text(
          l.reviewVerdict,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _Reason extends StatelessWidget {
  const _Reason({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 17, color: KingColors.burgundy),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
