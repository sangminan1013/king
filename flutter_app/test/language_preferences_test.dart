import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:king/src/app.dart";
import "package:king/src/language_preferences.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class _MemoryPreferences implements SharedPreferencesAsync {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: "https://example.invalid",
      publishableKey: "test-key",
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: false,
        detectSessionInUri: false,
        localStorage: EmptyLocalStorage(),
      ),
    );
  });
  tearDownAll(() => Supabase.instance.dispose());

  testWidgets(
      "starts in English, switches both ways, and restores after restart",
      (tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.localeTestValue = const Locale("ko", "KR");
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final storage = _MemoryPreferences();
    Future<void> openApp() async {
      final preferences = LanguagePreferences(storage);
      addTearDown(preferences.dispose);
      await preferences.restore();
      await tester.pumpWidget(KingApp(languages: preferences));
      await tester.pumpAndSettle();
    }

    await openApp();
    expect(find.text("A Court of Wisdom"), findsOneWidget);
    await tester.tap(find.byTooltip("Settings"));
    await tester.pumpAndSettle();
    expect(find.text("Language"), findsOneWidget);
    await tester.tap(find.text("한국어 (Korean)"));
    await tester.pumpAndSettle();
    expect(find.text("언어"), findsOneWidget);
    final group = tester.widget<RadioGroup<Locale>>(
      find.byType(RadioGroup<Locale>),
    );
    expect(group.groupValue, const Locale("ko"));
    await tester.tap(find.byTooltip("뒤로 가기"));
    await tester.pumpAndSettle();
    expect(find.text("지혜가 모이는 어전"), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await openApp();
    expect(find.text("지혜가 모이는 어전"), findsOneWidget);
    await tester.tap(find.byTooltip("환경설정"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("English"));
    await tester.pumpAndSettle();
    expect(find.text("Language"), findsOneWidget);
    expect(storage.values[LanguagePreferences.storageKey], "en");
    await tester.tap(find.byTooltip("Back"));
    await tester.pumpAndSettle();
    expect(find.text("A Court of Wisdom"), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
