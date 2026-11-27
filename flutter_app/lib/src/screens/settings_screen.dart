import "package:flutter/material.dart";

import "../../l10n/strings.dart";
import "../language_preferences.dart";
import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({this.onSignOut, super.key});

  final Future<void> Function()? onSignOut;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool saving = false;

  Future<void> selectLanguage(
      LanguagePreferences languages, Locale? locale) async {
    if (saving || locale == null || locale == languages.locale) return;
    setState(() => saving = true);
    try {
      await languages.select(locale);
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.strings.languageSaveError)),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    final languages = LanguageScope.of(context);
    final text = Theme.of(context).textTheme;

    return RoyalScaffold(
      title: l.courtSettings,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 36),
        children: [
          RoyalPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: RoyalCrest(small: true),
                ),
                const SizedBox(height: 10),
                Text(l.language, style: text.headlineLarge),
                const SizedBox(height: 6),
                Text(l.languageDescription, style: text.bodyMedium),
                const SizedBox(height: 12),
                RadioGroup<Locale>(
                  groupValue: languages.locale,
                  onChanged: (locale) => selectLanguage(languages, locale),
                  child: Column(
                    children: [
                      RadioListTile<Locale>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.english),
                        value: const Locale("en"),
                        enabled: !saving,
                      ),
                      const Divider(color: KingColors.subtleBorder, height: 1),
                      RadioListTile<Locale>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.korean),
                        value: const Locale("ko"),
                        enabled: !saving,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          RoyalButton(
            label: l.home,
            style: RoyalButtonStyle.secondary,
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          if (widget.onSignOut case final signOut?) ...[
            const SizedBox(height: 10),
            RoyalButton(
              label: l.signOut,
              icon: Icons.logout,
              style: RoyalButtonStyle.ghost,
              onPressed: () async {
                Navigator.of(context).popUntil((route) => route.isFirst);
                await signOut();
              },
            ),
          ],
        ],
      ),
    );
  }
}
