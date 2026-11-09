import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/widgets/royal_widgets.dart';
import 'package:king/src/theme/king_theme.dart';

Widget page(String name, String? next) => Builder(
      builder: (context) => RoyalScaffold(
        title: name,
        child: next == null
            ? const Text('상세 내용')
            : TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => page(next, null)),
                ),
                child: const Text('상세 열기'),
              ),
      ),
    );

Future<void> openDetail(WidgetTester tester) async {
  await tester.pumpWidget(MaterialApp(
    theme: KingTheme.light,
    home: Builder(builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => page('회의 기록', '회의 상세')),
        ),
        child: const Text('홈에서 기록 열기'),
      ),
    )),
  ));
  await tester.tap(find.text('홈에서 기록 열기'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('상세 열기'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('back returns one screen while home remains available', (tester) async {
    await openDetail(tester);
    expect(find.byTooltip('홈으로'), findsOneWidget);
    await tester.tap(find.byTooltip('뒤로 가기'));
    await tester.pumpAndSettle();
    expect(find.text('회의 기록'), findsOneWidget);
    expect(find.text('회의 상세'), findsNothing);
    expect(find.text('홈에서 기록 열기'), findsNothing);
  });

  testWidgets('home returns directly to root and removes intermediate routes', (tester) async {
    await openDetail(tester);
    await tester.tap(find.byTooltip('홈으로'));
    await tester.pumpAndSettle();
    expect(find.text('홈에서 기록 열기'), findsOneWidget);
    expect(find.byType(RoyalHeader), findsNothing);
    final context = tester.element(find.text('홈에서 기록 열기'));
    expect(Navigator.of(context).canPop(), isFalse);
  });
}
