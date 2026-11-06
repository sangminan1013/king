import "package:flutter/material.dart";

import "../theme/king_theme.dart";
import "../widgets/royal_widgets.dart";

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
    return RoyalScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 44, 28, 30),
        child: Column(
          children: [
            const Spacer(),
            const RoyalCrest(),
            const SizedBox(height: 12),
            const Kicker("ENTER THE KING'S COUNCIL"),
            const SizedBox(height: 8),
            Text(
              "King",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 58),
            ),
            const SizedBox(height: 15),
            Text(
              "이름 없이 평의회에 입장하세요",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "회원가입 없이 안전한 게스트 세션이 만들어집니다.\n의견에는 신원 정보가 표시되지 않습니다.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.7),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0x14B98F42),
                border: Border(left: BorderSide(color: KingColors.gold, width: 2)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: KingColors.burgundy),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      "게스트 세션은 이 기기에 보관됩니다. 로그아웃하거나 앱 데이터를 지우면 기존 신원을 복구할 수 없습니다.",
                      style: TextStyle(
                        color: KingColors.muted,
                        fontFamily: "sans-serif",
                        fontSize: 10,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (submitError != null) ...[
              const SizedBox(height: 16),
              Text(
                submitError!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: KingColors.burgundy,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
            const SizedBox(height: 22),
            RoyalButton(
              label: isSubmitting ? "게스트 세션을 만드는 중..." : "게스트로 입장하기",
              icon: Icons.theater_comedy_outlined,
              onPressed: isSubmitting ? null : enterAsGuest,
            ),
            const SizedBox(height: 18),
            const PrivacyNote("계정 등록 없이 익명 ID만 발급되며, 다른 참여자에게 공개되지 않습니다."),
          ],
        ),
      ),
    );
  }
}
