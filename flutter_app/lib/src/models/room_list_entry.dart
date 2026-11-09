class RoomListEntry {
  const RoomListEntry({
    required this.id,
    required this.code,
    required this.groupName,
    required this.topic,
    required this.status,
    required this.isOwner,
    required this.createdAt,
    this.finalizedAt,
  });

  final String id;
  final String code;
  final String groupName;
  final String topic;
  final String status;
  final bool isOwner;
  final DateTime createdAt;
  final DateTime? finalizedAt;

  bool get isFinalized => status == "finalized";

  factory RoomListEntry.fromJson(Map<String, dynamic> json, String userId) {
    return RoomListEntry(
      id: json["id"] as String,
      code: json["invite_code"] as String,
      groupName: json["group_name"] as String,
      topic: json["topic"] as String,
      status: json["status"] as String,
      isOwner: json["owner_id"] == userId,
      createdAt: DateTime.parse(json["created_at"] as String),
      finalizedAt: DateTime.tryParse(json["finalized_at"]?.toString() ?? ""),
    );
  }
}
