import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:king_app/room_repository.dart';

void main() {
  test('Flutter HTTP 저장소가 실제 Node 서버와 동일한 규격으로 통신한다', () async {
    final process = await Process.start('node', [
      '--input-type=module',
      '-e',
      "import {createApp} from './src/app.js'; const s=createApp(); s.listen(0,'127.0.0.1',()=>console.log(s.address().port));",
    ], workingDirectory: '../server');
    addTearDown(() async {
      process.kill();
      await process.exitCode;
    });
    final port = await process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .first
        .timeout(const Duration(seconds: 10));
    final repo = HttpRoomRepository('http://127.0.0.1:$port');
    addTearDown(repo.dispose);
    final room = await repo.create('연동 테스트', '점심', 3);
    expect((await repo.get(room.code)).name, '연동 테스트');
    await repo.act(room.code, 'opinions', {
      'author': '민수',
      'condition': '1만원',
      'text': '비빔밥',
    });
    final result = await repo.act(room.code, 'result');
    expect(result.result, contains('비빔밥'));
    final closed = await repo.act(room.code, 'finish');
    expect(closed.history.length, 1);
    expect(closed.closed, true);
    await expectLater(
      repo.act(room.code, 'next'),
      throwsA(isA<RoomException>()),
    );
  });
}
