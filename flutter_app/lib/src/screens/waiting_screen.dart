import "package:flutter/material.dart";

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
    final controller = widget.controller;
    final error = controller.roomError ?? controller.verdictError;
    return RoyalScaffold(
      title: "평결 대기",
      kicker: "ROOM · ${controller.roomCode}",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
        children: [
          const RoyalCrest(),
          const SizedBox(height: 20),
          Text(
            controller.isGeneratingVerdict
                ? "모두의 의견으로 평결을 준비하고 있습니다"
                : "의견이 봉인되었습니다",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(controller.topic, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text(
            "의견 제출 ${controller.submittedCount} / ${controller.memberLimit}명",
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
                ? "전원이 제출했습니다. 평결을 준비한 뒤 결과로 이동합니다."
                : "설정한 ${controller.memberLimit}명 모두의 제출을 기다리고 있어요.\n전원이 제출하기 전에는 평결을 만들지 않습니다.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (checking) const Center(child: CircularProgressIndicator()),
          if (error != null && !checking) ...[
            Text(error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: KingColors.burgundy)),
            const SizedBox(height: 12),
          ],
          RoyalButton(
            label: checking ? "확인하는 중..." : "제출 현황 확인",
            icon: Icons.refresh,
            onPressed: checking || leaving ? null : checkStatus,
          ),
          const SizedBox(height: 12),
          Text(
            "현황 확인을 누르면 최신 제출 상태를 확인합니다.\n전원 제출이 확인되면 평결을 생성하고 결과로 이동해요.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          InviteCodeTile(code: controller.roomCode),
        ],
      ),
    );
  }
}
