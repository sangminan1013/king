import "package:flutter/material.dart";

import "../../l10n/strings.dart";

import "../controller/king_controller.dart";
import "../data/demo_data.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "room_screen.dart";

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  late final TextEditingController groupController;
  late final TextEditingController topicController;

  @override
  void initState() {
    super.initState();
    groupController = TextEditingController(text: widget.controller.groupName);
    topicController = TextEditingController(text: widget.controller.topic);
    widget.controller.addListener(refresh);
  }

  bool initializedFields = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initializedFields) return;
    initializedFields = true;
    if (widget.controller.roomId == null &&
        groupController.text == DemoData.groupName) {
      groupController.text = context.strings.demoGroup;
    }
    if (widget.controller.roomId == null &&
        topicController.text == DemoData.topic) {
      topicController.text = context.strings.demoTopic;
    }
  }

  void refresh() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(refresh);
    groupController.dispose();
    topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    final canCreate = groupController.text.trim().isNotEmpty &&
        topicController.text.trim().isNotEmpty;

    return RoyalScaffold(
      title: l.convene,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
        children: [
          Text(l.createHeading,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 28),
          Text(l.groupName, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: groupController,
            maxLength: 24,
            onChanged: (value) {
              widget.controller.updateGroupName(value);
              setState(() {});
            },
          ),
          const SizedBox(height: 6),
          Text(l.topic, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: topicController,
            maxLength: 120,
            minLines: 3,
            maxLines: 4,
            onChanged: (value) {
              widget.controller.updateTopic(value);
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: KingColors.subtleBorder),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.members, style: Theme.of(context).textTheme.labelLarge),
                Text(l.membersDescription,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: KingColors.border),
                    borderRadius: BorderRadius.circular(4),
                    color: KingColors.paperLight,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: l.fewerMembers,
                        onPressed: widget.controller.memberLimit <= 2
                            ? null
                            : () => widget.controller.changeMemberLimit(-1),
                        icon: const Icon(Icons.remove),
                        color: KingColors.burgundy,
                      ),
                      Expanded(
                        child: Text(
                          l.memberCount(widget.controller.memberLimit),
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        tooltip: l.moreMembers,
                        onPressed: widget.controller.memberLimit >= 12
                            ? null
                            : () => widget.controller.changeMemberLimit(1),
                        icon: const Icon(Icons.add),
                        color: KingColors.burgundy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(l.chooseKing, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l.chooseKingDescription,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          KingPicker(
            selected: widget.controller.kingPersonality,
            onSelected: widget.controller.isRoomBusy
                ? null
                : widget.controller.selectKing,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: KingColors.wash,
              border:
                  Border(left: BorderSide(color: KingColors.gold, width: 2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.edit_note, color: KingColors.burgundy),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.petitionPrivacy,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          RoyalButton(
            label: widget.controller.isRoomBusy ? l.creating : l.convene,
            icon: Icons.workspace_premium_outlined,
            onPressed: canCreate && !widget.controller.isRoomBusy
                ? () async {
                    widget.controller.updateGroupName(groupController.text);
                    widget.controller.updateTopic(topicController.text);
                    final created = await widget.controller.createRoom();
                    if (!context.mounted || !created) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            RoomScreen(controller: widget.controller),
                      ),
                    );
                  }
                : null,
          ),
          if (widget.controller.roomError != null) ...[
            const SizedBox(height: 12),
            Text(
              l.errorMessage(widget.controller.roomError!),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: KingColors.burgundy,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
