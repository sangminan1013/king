import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:king/l10n/generated/king_localizations.dart";
import "package:king/src/controller/king_controller.dart";
import "package:king/src/models/ai_verdict.dart";
import "package:king/src/models/room_list_entry.dart";
import "package:king/src/screens/create_room_screen.dart";
import "package:king/src/screens/home_screen.dart";
import "package:king/src/screens/join_room_screen.dart";
import "package:king/src/screens/result_screen.dart";
import "package:king/src/screens/room_history_screen.dart";
import "package:king/src/screens/room_screen.dart";
import "package:king/src/screens/summary_screen.dart";
import "package:king/src/screens/waiting_screen.dart";
import "package:king/src/services/king_api_service.dart";
import "package:king/src/theme/king_theme.dart";
import "package:supabase_flutter/supabase_flutter.dart";

const savedVerdict = AiVerdict(
  title: "원래 저장된 결론",
  summary: "원래 저장된 설명",
  fitScore: 95,
  reasons: [VerdictReason(title: "Original reason", detail: "Original detail")],
);

class _CourtApi extends KingApiService {
  _CourtApi(SupabaseClient client) : super(supabase: client);

  @override
  Future<RoomSnapshot> getRoom(String roomId) async => const RoomSnapshot(
        id: "court",
        code: "KING-ABC",
        groupName: "원래 어전 이름",
        topic: "원래 안건",
        memberLimit: 12,
        memberCount: 2,
        submittedCount: 1,
        status: "collecting",
        isOwner: true,
        hasSubmitted: false,
        opinions: [],
      );

  @override
  Future<List<RoomListEntry>> listMyRooms({int offset = 0}) async => [];
}

void main() {
  late SupabaseClient client;
  setUpAll(() {
    client = SupabaseClient(
      "https://example.invalid",
      "test-key",
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
  });
  tearDownAll(() => client.dispose());

  for (final language in ["en", "ko"]) {
    testWidgets("major court screens fit at 320px with $language text",
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final controller = KingController(api: _CourtApi(client));
      addTearDown(controller.dispose);
      await controller.openRoom("court");

      Future<void> show(Widget screen) async {
        await tester.pumpWidget(MaterialApp(
          key: UniqueKey(),
          theme: KingTheme.light,
          localizationsDelegates: KingLocalizations.localizationsDelegates,
          supportedLocales: KingLocalizations.supportedLocales,
          locale: Locale(language),
          home: screen,
        ));
        await tester.pumpAndSettle();
      }

      Future<void> check(String english, String korean,
          {bool scroll = false}) async {
        final label = find.text(language == "en" ? english : korean);
        if (scroll) {
          await tester.scrollUntilVisible(label, 130,
              scrollable: find.byType(Scrollable).first);
        }
        expect(label, findsWidgets);
        expect(tester.takeException(), isNull);
      }

      await show(HomeScreen(controller: controller, onSignOut: () async {}));
      await check("A Court of Wisdom", "지혜가 모이는 어전");
      await show(CreateRoomScreen(controller: controller));
      await check("Choose Your King", "왕 선택", scroll: true);
      await check("The Festive King", "흥 많은 왕", scroll: true);
      await show(JoinRoomScreen(controller: controller));
      await check("Enter your invitation code", "초대 코드를 입력하세요");
      await check("Invitation code", "초대 코드");
      await check("4-character codes are not case-sensitive.",
          "4자리 코드는 대소문자 구분 없이 입력할 수 있어요.", scroll: true);
      await show(RoomScreen(controller: controller));
      await check("Submit a Petition", "상소문 올리기", scroll: true);
      await show(WaitingScreen(controller: controller));
      await check("Royal Deliberation", "어전 논의");
      await check("Check Submission Status", "제출 현황 확인", scroll: true);
      controller.verdict = savedVerdict;
      await show(ResultScreen(controller: controller));
      await check("Royal Verdict", "왕의 결론");
      expect(find.text(savedVerdict.title), findsOneWidget);
      await check("Confirm Decision", "결정 확정하기", scroll: true);
      await show(SummaryScreen(controller: controller));
      await check("Royal Decree", "왕명");
      expect(find.text(savedVerdict.summary), findsOneWidget);
      await show(RoomHistoryScreen(controller: controller));
      await check("Court Records", "어전 기록");
    });
  }
}
