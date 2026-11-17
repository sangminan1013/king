import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/controller/king_controller.dart';
import 'package:king/src/models/ai_verdict.dart';
import 'package:king/src/screens/result_screen.dart';
import 'package:king/src/screens/summary_screen.dart';
import 'package:king/src/services/king_api_service.dart';
import 'package:king/src/theme/king_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FinalizeApi extends KingApiService {
  FinalizeApi() : super(supabase: SupabaseClient('http://localhost', 'test',
      authOptions: const AuthClientOptions(autoRefreshToken: false)));
  bool fail = false;
  int calls = 0;
  @override
  Future<RoomSnapshot> finalizeRoom(String roomId) async {
    calls++;
    if (fail) throw const KingApiException('확정 실패');
    return RoomSnapshot(id: roomId, code: 'KING-ABC', groupName: '회의',
      topic: '점심', memberLimit: 2, memberCount: 2, submittedCount: 2,
      status: 'finalized', isOwner: true, hasSubmitted: true, opinions: const [],
      verdict: decision, finalizedAt: DateTime.utc(2026, 11, 17, 1));
  }
}
const decision = AiVerdict(title: '국밥', summary: '국밥으로 정하노라.', fitScore: 80, reasons: []);
Future<KingController> show(WidgetTester tester, FinalizeApi api, {bool owner = true}) async {
  tester.view.physicalSize = const Size(420, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final controller = KingController(api: api)..roomId = 'room'..isOwner = owner..verdict = decision;
  await tester.pumpWidget(MaterialApp(theme: KingTheme.light, home: ResultScreen(controller: controller)));
  await tester.pumpAndSettle();
  return controller;
}
void main() {
  testWidgets('confirm finalizes before showing record, with no second save button', (tester) async {
    final api = FinalizeApi();
    final controller = await show(tester, api);
    await tester.ensureVisible(find.text('결정 확정하기'));
    await tester.tap(find.text('결정 확정하기'));
    await tester.pumpAndSettle();
    expect(api.calls, 1);
    expect(controller.roomStatus, 'finalized');
    expect(find.byType(SummaryScreen), findsOneWidget);
    expect(find.text('확정된 결정입니다.'), findsOneWidget);
    expect(find.textContaining('확정 시각:'), findsOneWidget);
    expect(find.text('기록 저장하기'), findsNothing);
  });
  testWidgets('failure remains on result and permits retry', (tester) async {
    final api = FinalizeApi()..fail = true;
    await show(tester, api);
    await tester.ensureVisible(find.text('결정 확정하기'));
    await tester.tap(find.text('결정 확정하기'));
    await tester.pumpAndSettle();
    expect(find.byType(SummaryScreen), findsNothing);
    expect(find.text('확정 실패'), findsOneWidget);
    api.fail = false;
    await tester.tap(find.text('결정 확정하기'));
    await tester.pumpAndSettle();
    expect(api.calls, 2);
    expect(find.byType(SummaryScreen), findsOneWidget);
  });
  testWidgets('nonowner cannot finalize', (tester) async {
    final api = FinalizeApi();
    final controller = await show(tester, api, owner: false);
    expect(await controller.saveDecision(), isFalse);
    expect(api.calls, 0);
    expect(find.text('방장의 결정 확정을 기다리고 있습니다.'), findsOneWidget);
  });
}
