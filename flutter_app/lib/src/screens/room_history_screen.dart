import "package:flutter/material.dart";

import "../../l10n/strings.dart";

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
            ? (exception.displayKey ?? exception.message)
            : "ui:historyError";
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
        SnackBar(
            content: Text(context.strings.errorMessage(
                controller.roomError ?? context.strings.openRoomError))),
      );
    }
    if (mounted) setState(() => openingId = null);
  }

  Widget roomTile(RoomListEntry room) {
    final l = context.strings;
    final status = room.isFinalized ? l.archivedStatus : l.activeStatus;
    final date = formatCourtDate(context, room.finalizedAt ?? room.createdAt);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: KingColors.paperLight,
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
              room.isOwner ? "$status · ${l.host}" : status,
              style: const TextStyle(
                  color: KingColors.burgundy, fontWeight: FontWeight.w700),
            ),
            Text(
                "${room.code} · ${room.isFinalized ? l.finalizedAt(date) : l.createdAt(date)}"),
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
    final l = context.strings;
    return RoyalScaffold(
      title: l.history,
      child: RefreshIndicator(
        onRefresh: () => loadRooms(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(l.myCourts,
                        style: Theme.of(context).textTheme.headlineMedium)),
                IconButton(
                  tooltip: l.refreshCourts,
                  onPressed:
                      loading || openingId != null ? null : () => loadRooms(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Text(
              l.reopenCourts,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (loading && rooms.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator())),
            if (!loading && error == null && rooms.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(l.noCourts, textAlign: TextAlign.center),
              ),
            ...rooms.map(roomTile),
            if (error != null) ...[
              Text(l.errorMessage(error!),
                  style: const TextStyle(color: KingColors.burgundy)),
              TextButton(
                  onPressed: loading ? null : () => loadRooms(),
                  child: Text(l.reloadCourts)),
            ],
            if (rooms.isNotEmpty && hasMore)
              TextButton(
                onPressed: loading || openingId != null
                    ? null
                    : () => loadRooms(more: true),
                child: Text(loading ? l.loading : l.moreCourts),
              ),
            const SizedBox(height: 10),
            PrivacyNote(l.historyPrivacy),
          ],
        ),
      ),
    );
  }
}
