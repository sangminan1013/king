import "package:flutter/material.dart";

import "../../l10n/strings.dart";

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
    final l = context.strings;
    final controller = widget.controller;
    final verdict = controller.verdict!;
    return RoyalScaffold(
      title: l.decree,
      kicker: "${l.profile(controller.kingPersonality).name} · ${l.recorded}",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 45, 24, 40),
        children: [
          Kicker(l.recorded),
          const SizedBox(height: 9),
          Text(
            controller.groupName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 5),
          Text(
            l.memberCount(controller.memberCount),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 27),
          RoyalPanel(
            style: RoyalPanelStyle.decree,
            padding: const EdgeInsets.all(21),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Kicker(l.topic),
                const SizedBox(height: 8),
                Text(controller.topic,
                    style: Theme.of(context).textTheme.bodyMedium),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 17),
                  child: Divider(color: KingColors.subtleBorder, height: 1),
                ),
                Kicker(l.verdict),
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
                    border: Border(
                        left: BorderSide(color: KingColors.gold, width: 2)),
                  ),
                  child: Text(
                    verdict.summary,
                    style: KingTheme.decisionSummary,
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: SizedBox(width: 40, child: RoyalCrest(small: true))),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(l.confirmedDecision, textAlign: TextAlign.center),
          if (controller.finalizedAt != null)
            Text(
                l.finalizedAt(formatCourtDate(context, controller.finalizedAt!,
                    showTime: true)),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          RoyalButton(
            label: l.home,
            icon: Icons.home_outlined,
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
