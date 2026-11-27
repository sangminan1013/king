import "package:flutter/material.dart";

import "../../l10n/strings.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";
import "settings_screen.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.onGuest, super.key});

  final Future<String?> Function() onGuest;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSubmitting = false;
  String? submitError;

  Future<void> enterAsGuest() async {
    setState(() {
      isSubmitting = true;
      submitError = null;
    });
    final error = await widget.onGuest();
    if (!mounted) return;
    setState(() {
      isSubmitting = false;
      submitError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    final text = Theme.of(context).textTheme;
    return RoyalScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              tooltip: l.courtSettings,
              icon: const Icon(Icons.settings_outlined),
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen()),
                      ),
            ),
          ),
          const CourtHero(),
          const SizedBox(height: 22),
          RoyalPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l.guestHeading, style: text.headlineMedium),
                const SizedBox(height: 8),
                Text(l.guestDescription, style: text.bodyMedium),
                const SizedBox(height: 16),
                RoyalButton(
                  label: isSubmitting ? l.guestLoading : l.guestEnter,
                  icon: Icons.door_front_door_outlined,
                  onPressed: isSubmitting ? null : enterAsGuest,
                ),
                if (submitError case final error?) ...[
                  const SizedBox(height: 12),
                  Text(l.errorMessage(error),
                      style: text.bodyMedium
                          ?.copyWith(color: KingColors.burgundy)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          PrivacyNote(l.guestWarning),
        ],
      ),
    );
  }
}
