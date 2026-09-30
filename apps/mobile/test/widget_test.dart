import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_app/main.dart';

void main() {
  testWidgets('방 생성부터 의견 제출, 결과, 종료까지 진행된다', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const KingApp());
    await tester.tap(find.text('방 만들기'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '모프 팀');
    await tester.enterText(find.byType(TextFormField).at(1), '점심 메뉴');
    await tester.tap(find.text('방 만들고 코드 받기'));
    await tester.pumpAndSettle();
    expect(find.text('모프 팀'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), '민수');
    await tester.enterText(find.byType(TextFormField).at(1), '1만원 이하');
    await tester.enterText(find.byType(TextFormField).at(2), '비빔밥');
    await tester.ensureVisible(find.text('의견 제출'));
    await tester.tap(find.text('의견 제출'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('현재 의견으로 임시 결과 보기'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('현재 의견으로 임시 결과 보기'));
    await tester.pumpAndSettle();
    expect(find.textContaining('실제 AI 분석이 아닙니다.'), findsOneWidget);
    await tester.ensureVisible(find.text('종료하고 최종 기록 보기'));
    await tester.tap(find.text('종료하고 최종 기록 보기'));
    await tester.pumpAndSettle();
    expect(find.text('최종 요약 모음 · 데모'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
