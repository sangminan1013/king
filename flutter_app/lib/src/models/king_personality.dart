enum KingPersonality {
  wise('wise', '현명한 성군', '차분하고 공정한 왕',
      '소수의 제약까지 살피며 감정·현실·효율을 균형 있게 판단합니다.',
      '짐이 살펴보니 이 길이 가장 합당하니라.', '모든 안건'),
  iron('iron', '철혈 군주', '빠르고 단호한 효율의 왕',
      '실현 가능성, 시간과 비용 절감, 실행 효율을 우선합니다.',
      '군더더기 없이 이쪽으로 가라.', '역할 분담 · 일정'),
  festive('festive', '흥 많은 왕', '유쾌하고 활기찬 왕',
      '필수 조건 안에서 재미와 새로움, 함께 즐길 경험을 우선합니다.',
      '오늘은 이쪽이 제격이니라!', 'MT · 메뉴 · 밸런스 게임'),
  sentimental('sentimental', '감성많은 왕', '따뜻하고 서정적인 왕',
      '효율보다 마음의 편안함, 분위기와 경험의 가치를 우선합니다.',
      '마음이 편히 흐르는 이 길을 택하거라.', '분위기 · 낭만 · 경험'),
  tyrant('tyrant', '폭군', '투덜대지만 결단은 빠른 왕',
      '번거로운 일을 줄이고 빠르게 실행할 수 있는 선택을 택합니다.',
      '허, 고민은 여기까지다. 이쪽으로 가거라.', '가벼운 고민 · 장난스러운 결정');

  const KingPersonality(this.id, this.label, this.character, this.priorities,
      this.example, this.situations);

  final String id;
  final String label;
  final String character;
  final String priorities;
  final String example;
  final String situations;

  static KingPersonality fromId(String? id) => values.firstWhere(
      (personality) => personality.id == id,
      orElse: () => wise);
}
