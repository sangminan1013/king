import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/controller/king_controller.dart';
import 'package:king/src/models/ai_verdict.dart';
import 'package:king/src/models/room_list_entry.dart';
import 'package:king/src/screens/home_screen.dart';
import 'package:king/src/screens/room_history_screen.dart';
import 'package:king/src/screens/room_screen.dart';
import 'package:king/src/screens/summary_screen.dart';
import 'package:king/src/services/king_api_service.dart';
import 'package:king/src/theme/king_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

RoomListEntry entry(String id, {bool finalized = false}) => RoomListEntry(
      id: id,
      code: 'KING-$id',
      groupName: '회의 $id',
      topic: '안건 $id',
      status: finalized ? 'finalized' : 'collecting',
      isOwner: true,
      createdAt: DateTime(2026, 11, 9),
    );

RoomSnapshot snapshot(String id, {bool finalized = false}) => RoomSnapshot(
      id: id,
      code: 'KING-$id',
      groupName: '회의 $id',
      topic: '안건 $id',
      memberLimit: 5,
      memberCount: 2,
      submittedCount: finalized ? 2 : 0,
      status: finalized ? 'finalized' : 'collecting',
      isOwner: true,
      hasSubmitted: finalized,
      opinions: const [],
      verdict: finalized
          ? const AiVerdict(
              title: '저장된 결정',
              summary: '저장된 요약',
              fitScore: 80,
              reasons: [],
            )
          : null,
    );

class FakeApi extends KingApiService {
  FakeApi()
      : super(
            supabase: SupabaseClient('http://localhost', 'public-test-key',
                authOptions: const AuthClientOptions(autoRefreshToken: false)));
  List<RoomListEntry> entries = [];
  bool fail = false;
  int listCalls = 0;
  int verdictCalls = 0;
  final offsets = <int>[];

  @override
  Future<List<RoomListEntry>> listMyRooms({int offset = 0}) async {
    listCalls++;
    offsets.add(offset);
    if (fail) throw const KingApiException('목록 조회 실패');
    return entries.skip(offset).take(KingApiService.roomPageSize).toList();
  }

  @override
  Future<RoomSnapshot> getRoom(String roomId) async {
    if (fail) throw const KingApiException('회의 접근 불가');
    return snapshot(roomId,
        finalized: entries.firstWhere((r) => r.id == roomId).isFinalized);
  }

  @override
  Future<RoomSnapshot> generateVerdict(String roomId) async {
    verdictCalls++;
    throw StateError('Reading history must not request AI');
  }
}

Future<void> showHome(WidgetTester tester, FakeApi api,
    {bool openHistory = true}) async {
  tester.view.physicalSize = const Size(420, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MaterialApp(
    theme: KingTheme.light,
    home: HomeScreen(
        controller: KingController(api: api), onSignOut: () async {}),
  ));
  await tester.pumpAndSettle();
  if (openHistory) {
    await tapVisible(tester, find.text('회의 기록'));
  }
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
      'empty home keeps existing entry actions and fits a narrow screen',
      (tester) async {
    final api = FakeApi();
    await showHome(tester, api, openHistory: false);
    expect(find.text('새로운 회의 열기'), findsOneWidget);
    expect(find.text('초대 코드로 입장'), findsOneWidget);
    expect(find.byType(RoomHistoryScreen), findsNothing);
    expect(find.text('내 회의'), findsNothing);
    expect(api.listCalls, 0);
    await tapVisible(tester, find.text('회의 기록'));
    expect(find.byType(RoomHistoryScreen), findsOneWidget);
    expect(api.listCalls, 1);
    expect(find.textContaining('아직 참여한 회의가 없어요'), findsOneWidget);
    await tester.tap(find.byTooltip('뒤로 가기'));
    await tester.pumpAndSettle();
    expect(find.byType(RoomHistoryScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed list can be retried', (tester) async {
    final api = FakeApi()..fail = true;
    await showHome(tester, api);
    await tester.scrollUntilVisible(find.text('목록 다시 불러오기'), 200);
    expect(find.text('목록 조회 실패'), findsOneWidget);
    api.fail = false;
    api.entries = [entry('A')];
    await tapVisible(tester, find.text('목록 다시 불러오기'));
    expect(find.text('회의 A'), findsOneWidget);
  });

  testWidgets('active room opens without code and refreshes on return',
      (tester) async {
    final api = FakeApi()..entries = [entry('A')];
    await showHome(tester, api);
    await tapVisible(tester, find.text('회의 A'));
    expect(find.byType(RoomScreen), findsOneWidget);
    await tester.tap(find.byTooltip('뒤로 가기'));
    await tester.pumpAndSettle();
    expect(api.listCalls, 2);
  });

  testWidgets('archived room displays saved result without generating AI',
      (tester) async {
    final api = FakeApi()..entries = [entry('B', finalized: true)];
    await showHome(tester, api);
    await tapVisible(tester, find.text('회의 B'));
    expect(find.byType(SummaryScreen), findsOneWidget);
    expect(find.text('저장된 결정'), findsOneWidget);
    expect(find.text('참여자 2명'), findsOneWidget);
    expect(api.verdictCalls, 0);
    final save = tester.widget<OutlinedButton>(
      find.ancestor(
          of: find.text('기록이 저장되었습니다'), matching: find.byType(OutlinedButton)),
    );
    expect(save.onPressed, isNull);
  });

  testWidgets('room access failure stays in history', (tester) async {
    final api = FakeApi()..entries = [entry('A')];
    await showHome(tester, api);
    api.fail = true;
    await tapVisible(tester, find.text('회의 A'));
    expect(find.byType(RoomHistoryScreen), findsOneWidget);
    expect(find.text('회의 접근 불가'), findsOneWidget);
  });

  testWidgets('older rooms are reachable using pagination', (tester) async {
    final api = FakeApi()..entries = List.generate(21, (i) => entry('$i'));
    await showHome(tester, api);
    await tester.scrollUntilVisible(find.text('이전 회의 더 보기'), 500,
        maxScrolls: 30);
    await tapVisible(tester, find.text('이전 회의 더 보기'));
    await tester.scrollUntilVisible(find.text('회의 20'), 200);
    expect(api.offsets, [0, 20]);
    expect(find.text('회의 20'), findsOneWidget);
  });

  test('switching rooms clears draft and restores saved state', () async {
    final api = FakeApi()..entries = [entry('A'), entry('B', finalized: true)];
    final controller = KingController(api: api);
    await controller.openRoom('A');
    controller.updateOpinion('이전 회의에 입력한 임시 의견');
    controller.verdictError = '이전 오류';
    expect(await controller.openRoom('B'), isTrue);
    expect(controller.opinion, isEmpty);
    expect(controller.verdictError, isNull);
    expect(controller.isRecordSaved, isTrue);
    expect(controller.verdict?.title, '저장된 결정');
  });
}
