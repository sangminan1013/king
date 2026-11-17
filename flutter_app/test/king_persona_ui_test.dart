import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/screens/king_selection_screen.dart';
import 'package:king/src/theme/king_persona.dart';
import 'package:king/src/theme/king_theme.dart';

void main() {
  for (final king in KingPersona.values) {
    testWidgets(
        '${king.title}: selection preserves identity and preview is local',
        (tester) async {
      tester.view.resetPhysicalSize();
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      KingPersona? chosen;
      await tester.pumpWidget(MaterialApp(
          theme: KingTheme.light,
          home: KingSelectionScreen(onSelected: (value) => chosen = value)));
      final card = find.text(king.title);
      await tester.scrollUntilVisible(card, 250);
      await tester.tap(card);
      await tester.pump();
      expect(chosen, king);
      final preview = find.text('${king.title} 의견지 미리보기');
      await tester.ensureVisible(preview);
      await tester.tap(preview);
      await tester.pumpAndSettle();
      expect(find.text(king.writingTitle), findsOneWidget);
      await tester.enterText(find.byType(TextField), '내 의견을 적어보는 미리보기입니다.');
      await tester.pump();
      expect(find.text('미리보기에서는 의견을 전송하지 않습니다.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
