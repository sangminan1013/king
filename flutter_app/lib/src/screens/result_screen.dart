import "package:flutter/material.dart";

import "../controller/king_controller.dart";
<<<<<<< HEAD
import "../models/ai_verdict.dart";
=======
>>>>>>> origin/main
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "create_room_screen.dart";
import "summary_screen.dart";

<<<<<<< HEAD
class ResultScreen extends StatefulWidget {
=======
class ResultScreen extends StatelessWidget {
>>>>>>> origin/main
  const ResultScreen({required this.controller, super.key});

  final KingController controller;

<<<<<<< HEAD
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(refresh);
    widget.controller.generateVerdict();
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
      child: controller.isGeneratingVerdict
          ? const _LoadingVerdict()
          : controller.verdictError != null
              ? _VerdictError(
                  message: controller.verdictError!,
                  onRetry: controller.retryVerdict,
                )
              : _VerdictContent(
                  controller: controller,
                  verdict: controller.verdict!,
                ),
    );
  }
}

class _LoadingVerdict extends StatelessWidget {
  const _LoadingVerdict();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoyalCrest(),
            SizedBox(height: 24),
            CircularProgressIndicator(color: KingColors.burgundy),
            SizedBox(height: 18),
            Text("익명 의견을 공정하게 살피고 있습니다"),
          ],
        ),
      ),
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
            const Icon(Icons.error_outline, color: KingColors.burgundy, size: 42),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 22),
            RoyalButton(
              label: "다시 평결 요청하기",
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
=======
  static const opinions = [
    "예산을 아끼되 모두가 함께 즐길 수 있는 곳이면 좋겠습니다.",
    "이동 시간이 짧고 실내 활동이 포함된 선택지를 선호합니다.",
    "새로운 경험도 좋지만 식사 선택권이 넓었으면 합니다.",
  ];

  @override
  Widget build(BuildContext context) {
    return RoyalScaffold(
      title: "AI의 평결",
      kicker: "THE VERDICT",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
        children: [
          const RoyalCrest(),
          const Kicker("THE COUNCIL HAS DECIDED"),
          const SizedBox(height: 12),
          Text(
            "도심 근교의\n복합 문화 공간",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: KingColors.burgundyDark,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "모두의 조건을 가장 균형 있게 충족하는 선택입니다.",
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  color: KingColors.burgundyDark,
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          "평결의 근거",
                          style: TextStyle(
                            color: Color(0xFFF8EDDA),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        "적합도 92%",
                        style: TextStyle(
                          color: KingColors.goldLight,
                          fontFamily: "sans-serif",
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const _Reason(title: "접근성", detail: "대중교통으로 40분 이내 이동 가능"),
                const _Reason(title: "선택의 폭", detail: "실내 활동과 다양한 식사 옵션을 함께 제공"),
                const _Reason(title: "예산 균형", detail: "설정된 1인 예산 범위 안에서 운영 가능"),
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
              style: TextStyle(fontFamily: "sans-serif", fontSize: 11, fontWeight: FontWeight.w700),
            ),
            children: [
              for (var index = 0; index < opinions.length; index++)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  color: Colors.white.withOpacity(.25),
                  child: Text(
                    "익명 ${index + 1}\n${opinions[index]}",
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
      ),
>>>>>>> origin/main
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
