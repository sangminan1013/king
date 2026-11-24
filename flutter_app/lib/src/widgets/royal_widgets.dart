import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../l10n/strings.dart";
import "../models/king_personality.dart";
import "../theme/king_theme.dart";
import "court_art.dart";

class RoyalScaffold extends StatelessWidget {
  const RoyalScaffold({
    required this.child,
    this.title,
    this.kicker,
    this.onBack,
    super.key,
  });

  final Widget child;
  final String? title;
  final String? kicker;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const RepaintBoundary(child: CourtArt(CourtMotif.paper)),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 130,
            child: Opacity(opacity: .18, child: CourtArt(CourtMotif.landscape)),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 14,
                  child: CourtArt(CourtMotif.eave),
                ),
                if (title != null)
                  RoyalHeader(title: title!, kicker: kicker, onBack: onBack),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: SizedBox.expand(child: child),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoyalHeader extends StatelessWidget {
  const RoyalHeader({
    required this.title,
    this.kicker,
    this.onBack,
    super.key,
  });

  final String title;
  final String? kicker;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: KingColors.burgundyDark,
        border: Border(
          bottom: BorderSide(color: KingColors.gold, width: 2),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              color: KingColors.paperLight,
              icon: const Icon(Icons.chevron_left),
              tooltip: context.strings.back,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kicker case final caption?) Kicker(caption, light: true),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: KingColors.paperLight),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 44,
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              color: KingColors.paperLight,
              icon: const Icon(Icons.home_outlined),
              tooltip: context.strings.home,
            ),
          ),
        ],
      ),
    );
  }
}

class RoyalCrest extends StatelessWidget {
  const RoyalCrest({this.small = false, super.key});

  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 36.0 : 54.0;
    return Center(
      child: SizedBox.square(
          dimension: size, child: const CourtArt(CourtMotif.seal)),
    );
  }
}

class CourtHero extends StatelessWidget {
  const CourtHero({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    final text = Theme.of(context).textTheme;
    return RoyalPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12, child: CourtArt(CourtMotif.eave)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 2),
            child: Column(
              children: [
                const RoyalCrest(small: true),
                const SizedBox(height: 10),
                Text(l.brand,
                    textAlign: TextAlign.center, style: text.displayLarge),
                const SizedBox(height: 10),
                Text(l.slogan,
                    textAlign: TextAlign.center, style: text.titleMedium),
              ],
            ),
          ),
          const AspectRatio(
              aspectRatio: 3.6, child: CourtArt(CourtMotif.landscape)),
        ],
      ),
    );
  }
}

enum RoyalPanelStyle { paper, decree }

class RoyalPanel extends StatelessWidget {
  const RoyalPanel({
    required this.child,
    this.style = RoyalPanelStyle.paper,
    this.padding = const EdgeInsets.all(18),
    super.key,
  });

  final Widget child;
  final RoyalPanelStyle style;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDecree = style == RoyalPanelStyle.decree;
    return Material(
      color: KingColors.paperLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        side: BorderSide(color: KingColors.gold),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isDecree) const _ScrollEdge(),
          Padding(padding: padding, child: child),
          if (isDecree) const _ScrollEdge(),
        ],
      ),
    );
  }
}

class _ScrollEdge extends StatelessWidget {
  const _ScrollEdge();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [KingColors.brown, KingColors.gold, KingColors.brown]),
          border: Border(bottom: BorderSide(color: KingColors.goldLight)),
        ),
        child: SizedBox(height: 8),
      );
}

class KingPicker extends StatelessWidget {
  const KingPicker(
      {required this.selected, required this.onSelected, super.key});

  final KingPersonality selected;
  final ValueChanged<KingPersonality>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    final text = Theme.of(context).textTheme;
    final profile = l.profile(selected);
    return RoyalPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 8.0;
              final columns = constraints.maxWidth >= 500
                  ? 5
                  : constraints.maxWidth >= 330
                      ? 3
                      : 2;
              final tileWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final king in KingPersonality.values)
                    SizedBox(
                      width: tileWidth,
                      child: _KingPortraitTile(
                        key: ValueKey(king),
                        king: king,
                        name: l.profile(king).name,
                        selected: selected == king,
                        onPressed:
                            onSelected == null ? null : () => onSelected!(king),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: KingColors.subtleBorder, height: 1),
          const SizedBox(height: 12),
          Text(profile.name, style: text.titleMedium),
          Text(profile.character, style: text.bodySmall),
          const SizedBox(height: 5),
          Text(profile.priorities, style: text.bodyMedium),
          const SizedBox(height: 10),
          Text(l.kingSituation(profile.situations), style: text.bodySmall),
          const SizedBox(height: 6),
          Text(l.kingExample(profile.example), style: text.bodyMedium),
        ],
      ),
    );
  }
}

class _KingPortraitTile extends StatelessWidget {
  const _KingPortraitTile({
    required this.king,
    required this.name,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final KingPersonality king;
  final String name;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
          backgroundColor: selected ? KingColors.paperDeep : KingColors.paper,
          foregroundColor: KingColors.burgundyDark,
          side: BorderSide(
            color: selected ? KingColors.burgundy : KingColors.gold,
            width: selected ? 1.5 : 1,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 55,
              child: CourtArt(CourtMotif.portrait, portraitVariant: king.index),
            ),
            const SizedBox(height: 6),
            Text(name, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

String formatCourtDate(BuildContext context, DateTime date,
    {bool showTime = false}) {
  final format = MaterialLocalizations.of(context);
  final local = date.toLocal();
  final day = format.formatShortDate(local);
  if (!showTime) return day;
  final time = format.formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );
  return "$day · $time";
}

class Kicker extends StatelessWidget {
  const Kicker(this.text, {this.light = false, super.key});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: light ? KingColors.goldLight : KingColors.burgundy,
        fontFamily: KingTheme.sans,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

enum RoyalButtonStyle { primary, secondary, ghost }

class RoyalButton extends StatelessWidget {
  const RoyalButton({
    required this.label,
    this.icon,
    this.onPressed,
    this.style = RoyalButtonStyle.primary,
    this.subtitle,
    super.key,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final RoyalButtonStyle style;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isPrimary = style == RoyalButtonStyle.primary;
    final isGhost = style == RoyalButtonStyle.ghost;
    final foreground =
        isPrimary ? KingColors.paperLight : KingColors.burgundyDark;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: foreground,
          backgroundColor: isPrimary
              ? KingColors.burgundy
              : isGhost
                  ? Colors.transparent
                  : KingColors.paperLight,
          side: BorderSide(
            color: isGhost ? Colors.transparent : KingColors.gold,
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 21),
              const SizedBox(width: 11),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: subtitle == null
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: KingTheme.sans,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: foreground.withValues(alpha: .9),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyNote extends StatelessWidget {
  const PrivacyNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 14, color: KingColors.muted),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class InviteCodeTile extends StatefulWidget {
  const InviteCodeTile({required this.code, super.key});

  final String code;

  @override
  State<InviteCodeTile> createState() => _InviteCodeTileState();
}

class _InviteCodeTileState extends State<InviteCodeTile> {
  bool copied = false;

  Future<void> copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (mounted) setState(() => copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.strings;
    return RoyalPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.inviteCode,
                    style: Theme.of(context).textTheme.bodySmall),
                Text(
                  widget.code,
                  style: const TextStyle(
                    color: KingColors.burgundy,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: copy,
            icon: Icon(copied ? Icons.check : Icons.copy_outlined, size: 17),
            label: Text(copied ? l.copied : l.copy),
          ),
        ],
      ),
    );
  }
}
