import "package:flutter/material.dart";
<<<<<<< HEAD
import "package:supabase_flutter/supabase_flutter.dart";

import "src/app.dart";
import "src/config/supabase_config.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
=======

import "src/app.dart";

void main() {
>>>>>>> origin/main
  runApp(const KingApp());
}
