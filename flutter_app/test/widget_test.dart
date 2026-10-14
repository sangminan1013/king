import "package:flutter_test/flutter_test.dart";
import "package:king/src/app.dart";

void main() {
  testWidgets("shows the King home screen", (tester) async {
    await tester.pumpWidget(const KingApp());

    expect(find.text("King"), findsOneWidget);
    expect(find.text("새로운 회의 열기"), findsOneWidget);
    expect(find.text("초대 코드로 입장"), findsOneWidget);
  });
}
