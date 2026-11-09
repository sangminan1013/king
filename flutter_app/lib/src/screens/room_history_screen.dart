import "package:flutter/material.dart";

import "../controller/king_controller.dart";
import "../models/room_list_entry.dart";
import "../services/king_api_service.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "room_screen.dart";
import "summary_screen.dart";

class RoomHistoryScreen extends StatefulWidget {
  const RoomHistoryScreen({required this.controller, super.key});

  final KingController controller;

  @override
  State<RoomHistoryScreen> createState() => _RoomHistoryScreenState();
}

class _RoomHistoryScreenState extends State<RoomHistoryScreen> {
  List<RoomListEntry> rooms = [];
  bool loading = false;
  bool hasMore = true;
  String? error;
  String? openingId;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  Future<void> loadRooms({bool more = false}) async {
    if (loading) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final page = await widget.controller.listMyRooms(
        offset: more ? rooms.length : 0,
      );
      if (!mounted) return;
      setState(() {
        rooms = more ? [...rooms, ...page] : page;
        hasMore = page.length == KingApiService.roomPageSize;
      });
    } catch (exception) {
      if (!mounted) return;
      setState(() {
        error = exception is KingApiException
            ? exception.message
            : "회의 목록을 불러오지 못했습니다. 다시 시도해 주세요.";
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> open(Widget screen) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
    if (mounted) await loadRooms();
  }

  Future<void> openRoom(RoomListEntry room) async {
    if (openingId != null) return;
    setState(() => openingId = room.id);
    final controller = widget.controller;
    final success = await controller.openRoom(room.id);
    if (!mounted) return;
    if (success) {
      await open(controller.roomStatus == "finalized"
          ? SummaryScreen(controller: controller)
          : RoomScreen(controller: controller));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.roomError ?? "회의를 열지 못했습니다.")),
      );
    }
    if (mounted) setState(() => openingId = null);
  }

  String dateLabel(DateTime value) {
    final date = value.toLocal();
    return "${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}";
  }

  Widget roomTile(RoomListEntry room) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color(0x66FFFFFF),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        enabled: openingId == null,
        onTap: () => openRoom(room),
        title:
            Text(room.groupName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(room.topic, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 7),
            Text(
              "${room.isFinalized ? '종료 · 기록 보기' : '진행 중 · 다시 입장'}${room.isOwner ? ' · 방장' : ''}",
              style: const TextStyle(
                  color: KingColors.burgundy, fontWeight: FontWeight.w700),
            ),
            Text(
                "${room.code} · ${room.isFinalized ? '확정' : '생성'} ${dateLabel(room.finalizedAt ?? room.createdAt)}"),
          ],
        ),
        trailing: openingId == room.id
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoyalScaffold(
      title: "회의 기록",
      kicker: "MY COUNCILS",
      child: RefreshIndicator(
        onRefresh: () => loadRooms(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          children: [
            Row(
              children: [
                Expanded(
                    child: Text("내 회의",
                        style: Theme.of(context).textTheme.headlineMedium)),
                IconButton(
                  tooltip: "회의 목록 새로고침",
                  onPressed:
                      loading || openingId != null ? null : () => loadRooms(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Text(
              "참여한 회의와 이전 기록을 코드 없이 다시 열 수 있어요.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (loading && rooms.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator())),
            if (!loading && error == null && rooms.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text("아직 참여한 회의가 없어요.\n회의를 만들거나 초대 코드로 입장해 보세요.",
                    textAlign: TextAlign.center),
              ),
            ...rooms.map(roomTile),
            if (error != null) ...[
              Text(error!, style: const TextStyle(color: KingColors.burgundy)),
              TextButton(
                  onPressed: loading ? null : () => loadRooms(),
                  child: const Text("목록 다시 불러오기")),
            ],
            if (rooms.isNotEmpty && hasMore)
              TextButton(
                onPressed: loading || openingId != null
                    ? null
                    : () => loadRooms(more: true),
                child: Text(loading ? "불러오는 중..." : "이전 회의 더 보기"),
              ),
            const SizedBox(height: 10),
            const PrivacyNote("현재 게스트 세션의 기록입니다. 세션을 잃으면 목록을 복구할 수 없어요."),
          ],
        ),
      ),
    );
  }
}
