import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../theme/king_theme.dart";

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
      body: Container(
        decoration: const BoxDecoration(
          color: KingColors.paper,
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [Color(0xFFFFF9EA), KingColors.paper],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (title != null)
                RoyalHeader(
                  title: title!,
                  kicker: kicker ?? "THE COUNCIL",
                  onBack: onBack,
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class RoyalHeader extends StatelessWidget {
  const RoyalHeader({
    required this.title,
    required this.kicker,
    this.onBack,
    super.key,
  });

  final String title;
  final String kicker;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
              onPressed: onBack ?? () => Navigator.of(context).pop(),
              color: const Color(0xFFF8EEDB),
              icon: const Icon(Icons.chevron_left),
              tooltip: "뒤로 가기",
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Kicker(kicker, light: true),
                const SizedBox(height: 3),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFF8EEDB),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 44, child: RoyalCrest(small: true)),
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
    final size = small ? 38.0 : 92.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0.785398,
            child: Container(
              width: size * .64,
              height: size * .64,
              decoration: BoxDecoration(
                border: Border.all(
                  color: small ? KingColors.goldLight : KingColors.gold,
                ),
              ),
            ),
          ),
          Icon(
            Icons.workspace_premium_outlined,
            size: size * .55,
            color: small ? KingColors.goldLight : KingColors.burgundy,
          ),
        ],
      ),
    );
  }
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
        fontFamily: "sans-serif",
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
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
    final foreground = isPrimary ? const Color(0xFFFFF8E9) : KingColors.burgundyDark;

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
                  : Colors.white.withOpacity(.28),
          side: BorderSide(
            color: isPrimary || isGhost ? Colors.transparent : const Color(0xFFA88B64),
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: "sans-serif",
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: foreground.withOpacity(.7),
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

class ChapterTitle extends StatelessWidget {
  const ChapterTitle({
    required this.number,
    required this.chapter,
    required this.title,
    super.key,
  });

  final String number;
  final String chapter;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.rotate(
          angle: .785398,
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(color: KingColors.gold)),
            child: Transform.rotate(
              angle: -.785398,
              child: Text(
                number,
                style: const TextStyle(color: KingColors.burgundy, fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 17),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapter,
                style: const TextStyle(
                  color: KingColors.burgundy,
                  fontFamily: "sans-serif",
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
        ),
      ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.28),
        border: Border.all(color: const Color(0xFFB9A687)),
      ),
      child: Row(
        children: [
          Text("초대 코드", style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.code,
              style: const TextStyle(
                color: KingColors.burgundy,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: copy,
            icon: Icon(copied ? Icons.check : Icons.copy_outlined, size: 17),
            label: Text(copied ? "복사됨" : "복사"),
          ),
        ],
      ),
    );
  }
}
