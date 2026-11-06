import "package:flutter/material.dart";

import "controller/king_controller.dart";
<<<<<<< HEAD
import "screens/auth_screen.dart";
import "screens/home_screen.dart";
import "services/supabase_auth_service.dart";
=======
import "screens/home_screen.dart";
>>>>>>> origin/main
import "theme/king_theme.dart";

class KingApp extends StatefulWidget {
  const KingApp({super.key});

  @override
  State<KingApp> createState() => _KingAppState();
}

class _KingAppState extends State<KingApp> {
  final KingController controller = KingController();
<<<<<<< HEAD
  final SupabaseAuthService authService = SupabaseAuthService();
  bool isAuthenticated = false;
  bool isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    restoreSession();
  }

  Future<void> restoreSession() async {
    if (!mounted) return;
    setState(() {
      isAuthenticated = authService.hasSession;
      isCheckingSession = false;
    });
  }

  Future<String?> enterAsGuest() async {
    final error = await authService.signInAsGuest();
    if (error == null && mounted) {
      setState(() => isAuthenticated = true);
    }
    return error;
  }

  Future<void> signOut() async {
    await authService.signOut();
    controller.reset();
    if (mounted) setState(() => isAuthenticated = false);
  }
=======
>>>>>>> origin/main

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "King",
      debugShowCheckedModeBanner: false,
      theme: KingTheme.light,
<<<<<<< HEAD
      home: isCheckingSession
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : isAuthenticated
              ? HomeScreen(
                  controller: controller,
                  onSignOut: signOut,
                )
              : AuthScreen(onGuest: enterAsGuest),
=======
      home: HomeScreen(controller: controller),
>>>>>>> origin/main
    );
  }
}
