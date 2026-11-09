import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/controller/king_controller.dart';
import 'package:king/src/models/ai_verdict.dart';
import 'package:king/src/screens/room_screen.dart';
import 'package:king/src/screens/waiting_screen.dart';
import 'package:king/src/screens/result_screen.dart';
import 'package:king/src/services/king_api_service.dart';
import 'package:king/src/theme/king_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WaitingApi extends KingApiService {
  WaitingApi()
      : super(
            supabase: SupabaseClient('http://localhost', 'test',
                authOptions: const AuthClientOptions(autoRefreshToken: false)));
  int submitted = 1;
  int members = 2;
  bool hasSubmitted = true;
  bool stored = false;
  bool failRefresh = false;
  bool failVerdict = false;
  int verdictRequests = 0;

  RoomSnapshot get current => RoomSnapshot(
        id: 'room',
        code: 'KING-ABC',
        groupName: '팀 회의',
        topic: '점심 메뉴',
        memberLimit: 2,
        memberCount: members,
        submittedCount: submitted,
        status: 'collecting',
        isOwner: false,
        hasSubmitted: hasSubmitted,
        opinions: stored ? ['첫 번째 의견', '두 번째 의견'] : [],
        verdict: stored
            ? const AiVerdict(
                title: '함께 정한 메뉴',
                summary: '두 의견 모두 반영',
                fitScore: 80,
                reasons: [])
            : null,
      );

  @override
  Future<RoomSnapshot> getRoom(String roomId) async {
    if (failRefresh) throw const KingApiException('현황 조회 실패');
    return current;
  }

  @override
  Future<RoomSnapshot> submitOpinion(String roomId, String content) async {
    submitted++;
    hasSubmitted = true;
    return current;
  }

  @override
  Future<RoomSnapshot> generateVerdict(String roomId) async {
    verdictRequests++;
    if (submitted != 2 || members != 2) throw StateError('Premature AI call');
    if (failVerdict) throw const KingApiException('AI 생성 실패');
    stored = true;
    return current;
  }
}

Future<void> show(WidgetTester tester, Widget screen) async {
  tester.view.physicalSize = const Size(420, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(theme: KingTheme.light, home: screen));
  await tester.pumpAndSettle();
}

Future<void> check(WidgetTester tester) async {
  await tester.ensureVisible(find.text('제출 현황 확인'));
  await tester.tap(find.text('제출 현황 확인'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('submission navigates to waiting and never exposes preview',
      (tester) async {
    final api = WaitingApi()
      ..submitted = 0
      ..hasSubmitted = false;
    final controller = KingController(api: api);
    await controller.openRoom('room');
    await show(tester, RoomScreen(controller: controller));
    await tester.enterText(
        find.byType(TextField), '모두의 조건을 고려할 수 있는 충분히 긴 의견입니다.');
    await tester.pump();
    await tester.ensureVisible(find.text('의견 봉인하기'));
    await tester.tap(find.text('의견 봉인하기'));
    await tester.pumpAndSettle();
    expect(find.byType(WaitingScreen), findsOneWidget);
    expect(find.text('AI 평결 미리보기'), findsNothing);
    expect(find.text('의견 제출 1 / 2명'), findsOneWidget);
    expect(api.verdictRequests, 0);
  });

  testWidgets(
      'checking incomplete submissions stays waiting without generating',
      (tester) async {
    final api = WaitingApi();
    final controller = KingController(api: api);
    await controller.openRoom('room');
    await show(tester, WaitingScreen(controller: controller));
    await check(tester);
    expect(find.byType(WaitingScreen), findsOneWidget);
    expect(api.verdictRequests, 0);
  });

  testWidgets('all submissions generate once then navigate to result',
      (tester) async {
    final api = WaitingApi();
    final controller = KingController(api: api);
    await controller.openRoom('room');
    await show(tester, WaitingScreen(controller: controller));
    api.submitted = 2;
    await check(tester);
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.text('함께 정한 메뉴'), findsOneWidget);
    expect(api.verdictRequests, 1);
  });

  testWidgets('saved result is opened without requesting another verdict',
      (tester) async {
    final api = WaitingApi()
      ..submitted = 2
      ..stored = true;
    final controller = KingController(api: api);
    await controller.openRoom('room');
    await show(tester, WaitingScreen(controller: controller));
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(api.verdictRequests, 0);
  });

  testWidgets('refresh failure cannot use stale ready state to generate',
      (tester) async {
    final api = WaitingApi()..submitted = 2;
    final controller = KingController(api: api);
    await controller.openRoom('room');
    api.failRefresh = true;
    await show(tester, WaitingScreen(controller: controller));
    expect(find.text('현황 조회 실패'), findsOneWidget);
    expect(api.verdictRequests, 0);
    api.failRefresh = false;
    await check(tester);
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(api.verdictRequests, 1);
  });

  testWidgets('AI failure stays waiting and can be retried', (tester) async {
    final api = WaitingApi()
      ..submitted = 2
      ..failVerdict = true;
    final controller = KingController(api: api);
    await controller.openRoom('room');
    await show(tester, WaitingScreen(controller: controller));
    expect(find.text('AI 생성 실패'), findsOneWidget);
    expect(find.byType(ResultScreen), findsNothing);
    api.failVerdict = false;
    await check(tester);
    expect(find.byType(ResultScreen), findsOneWidget);
  });

  testWidgets('opening result directly never triggers AI or crashes on null',
      (tester) async {
    final api = WaitingApi();
    await show(tester, ResultScreen(controller: KingController(api: api)));
    expect(api.verdictRequests, 0);
    expect(tester.takeException(), isNull);
  });

  test('controller rejects direct generation with incomplete or unfilled room',
      () async {
    final api = WaitingApi();
    final controller = KingController(api: api);
    await controller.openRoom('room');
    expect(await controller.generateVerdict(), isFalse);
    api.submitted = 2;
    api.members = 1;
    expect(await controller.generateVerdict(), isFalse);
    expect(api.verdictRequests, 0);
  });
}
