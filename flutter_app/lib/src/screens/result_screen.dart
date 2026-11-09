import "package:flutter/material.dart";

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
    final controller = widget.controller;
    return RoyalScaffold(
      title: "AI의 평결",
      kicker: "THE VERDICT",
      child: controller.verdict == null
          ? _VerdictError(
              message: "평결이 아직 준비되지 않았습니다. 대기 화면에서 제출 현황을 확인해 주세요.",
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
    return Center(
      child: Padding(
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
              label: "돌아가기",
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
      children: [
        const RoyalCrest(),
        const Kicker("THE COUNCIL HAS DECIDED"),
        const SizedBox(height: 12),
        Text(
          verdict.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: KingColors.burgundyDark,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          verdict.summary,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.25),
            border: Border.all(color: const Color(0xFFAE9876)),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: KingColors.burgundyDark,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "평결의 근거",
                        style: TextStyle(
                          color: Color(0xFFF8EDDA),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      "적합도 ${verdict.fitScore}%",
                      style: const TextStyle(
                        color: KingColors.goldLight,
                        fontFamily: "sans-serif",
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              for (final reason in verdict.reasons)
                _Reason(title: reason.title, detail: reason.detail),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 4),
          shape: const Border(),
          collapsedShape: const Border(),
          title: const Text(
            "AI가 고려한 의견 보기",
            style: TextStyle(
              fontFamily: "sans-serif",
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            for (var index = 0; index < controller.opinions.length; index++)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                color: Colors.white.withOpacity(.25),
                child: Text(
                  "익명 ${index + 1}\n${controller.opinions[index]}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (controller.opinions.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  "평결이 확정되면 작성자 정보 없이 의견 내용만 표시됩니다.",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: RoyalButton(
                label: "다른 안건 시작",
                style: RoyalButtonStyle.secondary,
                onPressed: () {
                  controller.startAnotherDecision();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => CreateRoomScreen(controller: controller),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: RoyalButton(
                label: "결정 확정하기",
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SummaryScreen(controller: controller),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          "AI의 평결은 참여자 의견을 바탕으로 한 제안이며, 중요한 결정은 함께 다시 검토해 주세요.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 8),
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
