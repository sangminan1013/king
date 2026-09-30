class Opinion {
  final String author, condition, text;
  const Opinion(this.author, this.condition, this.text);
  factory Opinion.fromJson(Map<String, dynamic> j) =>
      Opinion(j['author'], j['condition'], j['text']);
}

class RoundResult {
  final int round;
  final String result;
  const RoundResult(this.round, this.result);
}

class Room {
  final String code, name, topic;
  final int capacity;
  int round;
  bool closed;
  String? result;
  final List<Opinion> opinions;
  final List<RoundResult> history;
  Room({
    required this.code,
    required this.name,
    required this.topic,
    required this.capacity,
    this.round = 1,
    this.closed = false,
    this.result,
    List<Opinion>? opinions,
    List<RoundResult>? history,
  }) : opinions = opinions ?? [],
       history = history ?? [];
  factory Room.fromJson(Map<String, dynamic> j) => Room(
    code: j['code'],
    name: j['name'],
    topic: j['topic'],
    capacity: j['capacity'],
    round: j['round'],
    closed: j['closed'],
    result: j['result'],
    opinions: (j['opinions'] as List).map((o) => Opinion.fromJson(o)).toList(),
    history: (j['history'] as List)
        .map((r) => RoundResult(r['round'], r['result']))
        .toList(),
  );
}
