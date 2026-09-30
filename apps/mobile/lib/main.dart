import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'room.dart';
import 'room_repository.dart';

void main() => runApp(const KingApp());

class KingApp extends StatelessWidget {
  const KingApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'KING',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF455B42)),
      scaffoldBackgroundColor: const Color(0xFFF6F7F2),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: const KingHome(),
  );
}

class KingHome extends StatefulWidget {
  const KingHome({super.key});
  @override
  State<KingHome> createState() => _KingHomeState();
}

class _KingHomeState extends State<KingHome> {
  static const _url = String.fromEnvironment('API_BASE_URL');
  late final RoomRepository _repo = _url.isEmpty
      ? DemoRoomRepository()
      : HttpRoomRepository(_url);
  final _name = TextEditingController(),
      _topic = TextEditingController(),
      _code = TextEditingController();
  final _author = TextEditingController(),
      _condition = TextEditingController(),
      _opinion = TextEditingController();
  final _createKey = GlobalKey<FormState>(),
      _opinionKey = GlobalKey<FormState>();
  Room? _room;
  String _page = 'home';
  int _capacity = 4;
  bool _busy = false;
  String? _error;
  @override
  void dispose() {
    for (final c in [_name, _topic, _code, _author, _condition, _opinion]) {
      c.dispose();
    }
    _repo.dispose();
    super.dispose();
  }

  Future<void> _run(
    Future<Room> Function() task, {
    bool clearInput = false,
  }) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final room = await task();
      if (!mounted) return;
      setState(() {
        _room = room;
        _page = 'room';
      });
      if (clearInput) {
        _condition.clear();
        _opinion.clear();
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _navigate(String page) => setState(() {
    _page = page;
    _error = null;
  });
  Widget _field(
    TextEditingController controller,
    String label, {
    int lines = 1,
    int max = 2000,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      maxLines: lines,
      maxLength: max,
      decoration: InputDecoration(labelText: label, counterText: ''),
      validator: (v) => v == null || v.trim().isEmpty ? '$label 입력해주세요.' : null,
    ),
  );
  Widget _button(
    String title,
    VoidCallback action, {
    IconData icon = Icons.arrow_forward,
  }) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: FilledButton.icon(
      onPressed: _busy ? null : action,
      icon: Icon(icon),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(title),
      ),
    ),
  );
  Widget _card(Widget child) => Card(
    elevation: 0,
    color: Colors.white,
    child: Padding(padding: const EdgeInsets.all(22), child: child),
  );
  Widget _heading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(height: 1.6, color: Colors.black54),
        ),
      ],
    ),
  );
  List<Widget> _home() => [
    _heading('다른 생각을 모아,\n하나의 결정으로.', 'KING은 함께 고민하고 결정하는 공간입니다.'),
    _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.forum_outlined, size: 48, color: Color(0xFF455B42)),
          const SizedBox(height: 18),
          const Text(
            '우리의 다음 결정을 시작해요',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          _button('방 만들기', () => _navigate('create'), icon: Icons.add),
          OutlinedButton(
            onPressed: () => _navigate('join'),
            child: const Text('코드로 방 들어가기'),
          ),
        ],
      ),
    ),
    if (_room != null)
      _button(
        '최근 방으로 돌아가기',
        () => _run(() => _repo.get(_room!.code)),
        icon: Icons.history,
      ),
    const SizedBox(height: 24),
    const Text(
      '01 방 만들기  →  02 의견 모으기  →  03 결과 확인',
      textAlign: TextAlign.center,
    ),
    const SizedBox(height: 24),
    const Text(
      '현재는 기본 흐름을 확인하는 프로토타입입니다. 로그인과 실제 AI 분석은 추후 연결됩니다.',
      style: TextStyle(color: Colors.black54, height: 1.6),
    ),
  ];
  List<Widget> _create() => [
    _heading('새로운 대화의 시작', '그룹 이름과 함께 이야기할 주제를 정해주세요.'),
    _card(
      Form(
        key: _createKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _field(_name, '그룹 이름', max: 80),
            _field(_topic, '논의할 주제', max: 200),
            Text('참여 인원  $_capacity명'),
            Slider(
              value: _capacity.toDouble(),
              min: 2,
              max: 20,
              divisions: 18,
              label: '$_capacity명',
              onChanged: (v) => setState(() => _capacity = v.round()),
            ),
            _button('방 만들고 코드 받기', () {
              if (_createKey.currentState!.validate()) {
                _run(
                  () => _repo.create(_name.text, _topic.text, _capacity),
                  clearInput: true,
                );
              }
            }),
          ],
        ),
      ),
    ),
  ];
  List<Widget> _join() => [
    _heading('함께할 방에 입장해요', '전달받은 6자리 참여 코드를 입력해주세요.'),
    _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _code,
            maxLength: 6,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: '참여 코드',
              hintText: 'A1B2C3',
            ),
          ),
          _button('입장하기', () {
            final code = _code.text.trim().toUpperCase();
            if (!RegExp(r'^[A-Z0-9]{6}$').hasMatch(code)) {
              setState(() => _error = '영문·숫자 6자리 코드를 입력해주세요.');
              return;
            }
            _run(() => _repo.get(code), clearInput: true);
          }),
        ],
      ),
    ),
  ];
  List<Widget> _roomPage() {
    final r = _room!;
    return [
      _heading(r.closed ? '우리의 대화 기록' : r.name, r.topic),
      _card(
        Row(
          children: [
            Expanded(
              child: Text(
                '참여 코드  ${r.code}',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              tooltip: '코드 복사',
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: r.code));
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('코드를 복사했습니다.')));
                }
              },
              icon: const Icon(Icons.copy_outlined),
            ),
            IconButton(
              tooltip: '새로고침',
              onPressed: _busy ? null : () => _run(() => _repo.get(r.code)),
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      if (r.closed) ...[
        const Text(
          '최종 요약 모음 · 데모',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...r.history.map(
          (h) => _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '안건 ${h.round}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SelectableText(h.result),
              ],
            ),
          ),
        ),
        _button('시작 화면으로', () => _navigate('home'), icon: Icons.home_outlined),
      ] else ...[
        Text(
          '안건 ${r.round}  ·  의견 ${r.opinions.length}/${r.capacity}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (r.result == null) ...[
          _card(
            Form(
              key: _opinionKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(_author, '이름 또는 별명', max: 40),
                  _field(_condition, '고려할 조건', lines: 2),
                  _field(_opinion, '나의 의견', lines: 3),
                  _button('의견 제출', () {
                    if (_opinionKey.currentState!.validate()) {
                      _run(
                        () => _repo.act(r.code, 'opinions', {
                          'author': _author.text,
                          'condition': _condition.text,
                          'text': _opinion.text,
                        }),
                        clearInput: true,
                      );
                    }
                  }, icon: Icons.send_outlined),
                ],
              ),
            ),
          ),
          ...r.opinions.map(
            (o) => _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.author,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '조건: ${o.condition}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(o.text),
                ],
              ),
            ),
          ),
          if (r.opinions.isNotEmpty)
            _button(
              '현재 의견으로 임시 결과 보기',
              () => _run(() => _repo.act(r.code, 'result')),
              icon: Icons.auto_awesome_outlined,
            ),
        ] else ...[
          _card(SelectableText(r.result!, style: const TextStyle(height: 1.7))),
          _button(
            '다른 안건으로 시작',
            () => _run(() => _repo.act(r.code, 'next'), clearInput: true),
            icon: Icons.add,
          ),
          OutlinedButton(
            onPressed: _busy
                ? null
                : () => _run(() => _repo.act(r.code, 'finish')),
            child: const Text('종료하고 최종 기록 보기'),
          ),
        ],
      ],
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'KING',
        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3),
      ),
      leading: _page == 'home'
          ? null
          : IconButton(
              tooltip: '시작 화면',
              onPressed: _busy ? null : () => _navigate('home'),
              icon: const Icon(Icons.arrow_back),
            ),
      actions: [
        IconButton(
          tooltip: '환경설정 및 연결 정보',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (c) => AlertDialog(
                title: const Text('연결 정보'),
                content: Text(
                  _url.isEmpty
                      ? '앱 단독 데모 모드\n\n방과 의견은 메모리에 저장됩니다. 앱을 종료하면 초기화되며 다른 기기와 공유되지 않습니다.\n\n서버 연결은 실행 시 API_BASE_URL로 설정합니다.'
                      : '서버 연결 모드\n$_url\n\n현재 서버는 메모리 저장소와 임시 결과를 사용합니다. 다른 참여자의 입력은 새로고침으로 확인하세요.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('확인'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: AbsorbPointer(
            absorbing: _busy,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  _url.isEmpty ? '●  앱 단독 데모' : '●  서버 연결',
                  style: const TextStyle(color: Color(0xFF455B42)),
                ),
                if (_busy)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: LinearProgressIndicator(),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ...switch (_page) {
                  'create' => _create(),
                  'join' => _join(),
                  'room' => _roomPage(),
                  _ => _home(),
                },
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
