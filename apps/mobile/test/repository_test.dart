import 'package:flutter_test/flutter_test.dart';
import 'package:king_app/room_repository.dart';

void main() {
  test('데모 방 코드, 중복 제출 방지, 안건 보관, 종료 상태', () async {
    final repo = DemoRoomRepository();
    final room = await repo.create('팀', '주제', 2);
    expect((await repo.get(room.code.toLowerCase())).name, '팀');
    await expectLater(
      repo.act(room.code, 'result'),
      throwsA(isA<RoomException>()),
    );
    final input = {'author': '가', 'condition': '조건', 'text': '의견'};
    await repo.act(room.code, 'opinions', input);
    await expectLater(
      repo.act(room.code, 'opinions', input),
      throwsA(isA<RoomException>()),
    );
    await repo.act(room.code, 'result');
    await repo.act(room.code, 'next');
    expect(room.history.length, 1);
    expect(room.opinions, isEmpty);
    expect(room.round, 2);
    await repo.act(room.code, 'opinions', input);
    await repo.act(room.code, 'result');
    await repo.act(room.code, 'finish');
    expect(room.history.length, 2);
    expect(room.closed, true);
    await expectLater(
      repo.act(room.code, 'next'),
      throwsA(isA<RoomException>()),
    );
  });
}
