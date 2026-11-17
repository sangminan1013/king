import 'package:flutter/material.dart';

/// Presentation only. Never sent to the API or used to generate a verdict.
enum KingPersona {
  wise(
      '현명한 성군',
      '모두의 뜻을 살피는 왕',
      '공정 · 균형 · 포용',
      '작은 목소리도 빠짐없이 들을 것이니라.',
      '의견을 자유롭게 적어주세요.',
      '모두의 뜻을 담은 상소',
      '궁중 병풍 · 홍색 곤룡포',
      Color(0xFF812C36),
      Color(0xFFFAF0DD),
      Icons.balance),
  iron(
      '철혈 군주',
      '군더더기 없는 결단',
      '효율 · 시간 · 실현 가능성',
      '시간과 비용, 반드시 지킬 조건을 고하라.',
      '의견을 자유롭게 적어주세요.',
      '명확한 결단을 위한 보고',
      '먹빛 흑룡포 · 절제된 군영',
      Color(0xFF263C50),
      Color(0xFFEAF0F2),
      Icons.shield_outlined),
  festive(
      '흥 많은 왕',
      '오늘의 즐거움을 위하여',
      '재미 · 활기 · 새로운 경험',
      '흥겨운 자리에 그대의 생각이 빠질 수 없도다!',
      '의견을 자유롭게 적어주세요.',
      '잔치를 여는 한마디',
      '청사초롱 · 풍악이 흐르는 연회',
      Color(0xFFA74725),
      Color(0xFFFFF1DE),
      Icons.celebration_outlined),
  tender(
      '감성많은 왕',
      '마음이 머무는 선택',
      '공감 · 분위기 · 경험',
      '마음이 편히 흐르는 쪽을 들려주거라.',
      '의견을 자유롭게 적어주세요.',
      '달빛 아래 쓰는 편지',
      '달 · 산수화 · 연꽃',
      Color(0xFF466F69),
      Color(0xFFEDF3ED),
      Icons.nightlight_round),
  tyrant(
      '폭군',
      '거침없이, 솔직하게',
      '단호 · 직설 · 장난',
      '이리 고민이 많으냐. 원하는 바를 똑바로 고하라!',
      '의견을 자유롭게 적어주세요.',
      '왕 앞에 올리는 직언',
      '검붉은 곤룡포 · 어보',
      Color(0xFF601F30),
      Color(0xFFF5E7E5),
      Icons.local_fire_department_outlined);

  const KingPersona(
      this.title,
      this.subtitle,
      this.traits,
      this.quote,
      this.hint,
      this.writingTitle,
      this.scene,
      this.color,
      this.paper,
      this.icon);
  final String title, subtitle, traits, quote, hint, writingTitle, scene;
  final Color color, paper;
  final IconData icon;
}
