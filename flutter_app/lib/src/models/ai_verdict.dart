class VerdictReason {
  const VerdictReason({required this.title, required this.detail});

  final String title;
  final String detail;

  factory VerdictReason.fromJson(Map<String, dynamic> json) {
    return VerdictReason(
      title: json["title"]?.toString() ?? "",
      detail: json["detail"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "detail": detail,
      };
}

class AiVerdict {
  const AiVerdict({
    required this.title,
    required this.summary,
    required this.fitScore,
    required this.reasons,
  });

  final String title;
  final String summary;
  final int fitScore;
  final List<VerdictReason> reasons;

  factory AiVerdict.fromJson(Map<String, dynamic> json) {
    final rawReasons = json["reasons"];
    return AiVerdict(
      title: json["title"]?.toString() ?? "",
      summary: json["summary"]?.toString() ?? "",
      fitScore:
          (json["fitScore"] as num?)?.round().clamp(0, 100).toInt() ?? 0,
      reasons: rawReasons is List
          ? rawReasons
              .whereType<Map<String, dynamic>>()
              .map(VerdictReason.fromJson)
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "summary": summary,
        "fitScore": fitScore,
        "reasons": reasons.map((reason) => reason.toJson()).toList(),
      };
}
