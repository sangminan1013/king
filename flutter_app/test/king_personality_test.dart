import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king/src/controller/king_controller.dart';
import 'package:king/src/models/king_personality.dart';
import 'package:king/src/screens/create_room_screen.dart';
import 'package:king/src/services/king_api_service.dart';
import 'package:king/src/theme/king_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalityApi extends KingApiService {
  PersonalityApi() : super(supabase: SupabaseClient('http://localhost', 'test',
      authOptions: const AuthClientOptions(autoRefreshToken: false)));
  String saved = 'wise';
  RoomSnapshot get snapshot => RoomSnapshot(
      id: 'room', code: 'KING-ABC', groupName: '모임', topic: '점심',
      memberLimit: 2, memberCount: 1, submittedCount: 0,
      status: 'collecting', isOwner: true, hasSubmitted: false,
      opinions: const [], kingPersonality: saved);
  @override
  Future<RoomSnapshot> createRoom({required String groupName,
      required String topic, required int memberLimit,
      String kingPersonality = 'wise'}) async {
    saved = kingPersonality;
    return snapshot;
  }
  @override
  Future<RoomSnapshot> getRoom(String roomId) async => snapshot;
}

void main() {
  test('selected king survives creation and reopening; new room resets default', () async {
    final api = PersonalityApi();
    final controller = KingController(api: api);
    controller.selectKing(KingPersonality.tyrant);
    expect(await controller.createRoom(), isTrue);
    expect(api.saved, 'tyrant');
    controller.startAnotherDecision();
    expect(controller.kingPersonality, KingPersonality.wise);
    expect(await controller.openRoom('room'), isTrue);
    expect(controller.kingPersonality, KingPersonality.tyrant);
    controller.reset();
    expect(controller.kingPersonality, KingPersonality.wise);
  });
  test('legacy snapshot defaults to wise king', () {
    expect(RoomSnapshot.fromJson({}).kingPersonality, 'wise');
    expect(KingPersonality.fromId('unknown'), KingPersonality.wise);
  });
  testWidgets('creator selects a king and sees priorities and sample voice', (tester) async {
    tester.view.physicalSize = const Size(420, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = KingController(api: PersonalityApi());
    await tester.pumpWidget(MaterialApp(theme: KingTheme.light,
        home: CreateRoomScreen(controller: controller)));
    final dropdown = find.byType(DropdownButtonFormField<KingPersonality>);
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('흥 많은 왕').last);
    await tester.pumpAndSettle();
    expect(controller.kingPersonality, KingPersonality.festive);
    await tester.ensureVisible(find.text(KingPersonality.festive.priorities));
    expect(find.text(KingPersonality.festive.priorities), findsOneWidget);
    expect(find.text('“${KingPersonality.festive.example}”'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
