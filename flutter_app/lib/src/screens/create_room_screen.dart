import "package:flutter/material.dart";

import "../controller/king_controller.dart";
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
    final canCreate = groupController.text.trim().isNotEmpty &&
        topicController.text.trim().isNotEmpty;

    return RoyalScaffold(
      title: "새 회의 열기",
      kicker: "CONVENE A COUNCIL",
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
        children: [
          const ChapterTitle(
            number: "I",
            chapter: "첫 번째 장",
            title: "회의의 이름을 정하세요",
          ),
          const SizedBox(height: 28),
          Text("그룹명", style: Theme.of(context).textTheme.labelLarge),
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
          Text("결정할 안건", style: Theme.of(context).textTheme.labelLarge),
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
                horizontal: BorderSide(color: Color(0x337B6248)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("참여 인원", style: Theme.of(context).textTheme.labelLarge),
                      Text("의견을 제출할 최대 인원", style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB8A585)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => widget.controller.changeMemberLimit(-1),
                        icon: const Icon(Icons.remove),
                        color: KingColors.burgundy,
                      ),
                      Text(
                        "${widget.controller.memberLimit}명",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        onPressed: () => widget.controller.changeMemberLimit(1),
                        icon: const Icon(Icons.add),
                        color: KingColors.burgundy,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0x14B98F42),
              border: Border(left: BorderSide(color: KingColors.gold, width: 2)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.edit_note, color: KingColors.burgundy),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "각 참여자의 의견은 서로에게 공개되지 않습니다. 모두 제출하면 AI 평결이 시작됩니다.",
                    style: TextStyle(
                      fontFamily: "sans-serif",
                      color: KingColors.muted,
                      fontSize: 10,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          RoyalButton(
            label: "회의 개설하기",
            icon: Icons.workspace_premium_outlined,
            onPressed: canCreate
                ? () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => RoomScreen(controller: widget.controller),
                      ),
                    )
                : null,
          ),
        ],
      ),
    );
  }
}
