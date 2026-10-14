import "package:flutter/material.dart";

import "controller/king_controller.dart";
import "screens/home_screen.dart";
import "theme/king_theme.dart";

class KingApp extends StatefulWidget {
  const KingApp({super.key});

  @override
  State<KingApp> createState() => _KingAppState();
}

class _KingAppState extends State<KingApp> {
  final KingController controller = KingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "King",
      debugShowCheckedModeBanner: false,
      theme: KingTheme.light,
      home: HomeScreen(controller: controller),
    );
  }
}
