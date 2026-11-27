import "package:flutter/widgets.dart";
import "package:shared_preferences/shared_preferences.dart";

class LanguagePreferences extends ChangeNotifier {
  LanguagePreferences(this._storage);

  static const storageKey = "king.ui.language";
  final SharedPreferencesAsync _storage;

  Locale _locale = const Locale("en");
  Locale get locale => _locale;

  Future<void> restore() async {
    try {
      if (await _storage.getString(storageKey) == "ko") {
        _locale = const Locale("ko");
      }
    } on Exception {
      // Start in English when local storage is unavailable.
    }
  }

  Future<void> select(Locale locale) async {
    if (locale == _locale) return;
    final previous = _locale;
    _locale = locale;
    notifyListeners();
    try {
      await _storage.setString(storageKey, locale.languageCode);
    } on Exception {
      _locale = previous;
      notifyListeners();
      rethrow;
    }
  }
}

class LanguageScope extends InheritedNotifier<LanguagePreferences> {
  const LanguageScope({
    required LanguagePreferences preferences,
    required super.child,
    super.key,
  }) : super(notifier: preferences);

  static LanguagePreferences of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LanguageScope>()!.notifier!;
}
