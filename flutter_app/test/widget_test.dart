import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:king/src/screens/auth_screen.dart";
import "package:king/src/theme/king_theme.dart";

void main() {
  testWidgets("shows the guest-only King entry screen", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: KingTheme.light,
        home: AuthScreen(onGuest: () async => null),
      ),
    );

    expect(find.text("King"), findsOneWidget);
    expect(find.text("게스트로 입장하기"), findsOneWidget);
    expect(find.text("로그인"), findsNothing);
    expect(find.text("회원가입"), findsNothing);
  });

  testWidgets("guest entry invokes anonymous authentication", (tester) async {
    var entered = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: KingTheme.light,
        home: AuthScreen(
          onGuest: () async {
            entered = true;
            return null;
          },
        ),
      ),
    );

    await tester.tap(find.text("게스트로 입장하기"));
    await tester.pumpAndSettle();
    expect(entered, isTrue);
  });
}
