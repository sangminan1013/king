enum KingPersonality {
  wise("wise"),
  iron("iron"),
  festive("festive"),
  sentimental("sentimental"),
  tyrant("tyrant");

  const KingPersonality(this.id);

  final String id;

  static KingPersonality fromId(String? id) => values.firstWhere(
        (personality) => personality.id == id,
        orElse: () => wise,
      );
}
