import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "src/app.dart";
import "src/config/supabase_config.dart";
import "src/language_preferences.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );
  final languages = LanguagePreferences(SharedPreferencesAsync());
  await languages.restore();
  runApp(KingApp(languages: languages));
}
