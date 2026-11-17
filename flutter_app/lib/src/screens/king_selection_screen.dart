import 'package:flutter/material.dart';
import '../theme/king_persona.dart';
import '../theme/king_theme.dart';
import '../widgets/korean_ornaments.dart';
import '../widgets/royal_widgets.dart';

class KingSelectionScreen extends StatelessWidget {
  const KingSelectionScreen({required this.onSelected, super.key});
  final ValueChanged<KingPersona> onSelected;
  @override
  Widget build(BuildContext context) => RoyalScaffold(
        title: '왕 선택',
        kicker: '다섯 왕의 어전',
        child: ListView(padding: const EdgeInsets.all(24), children: [
          const Center(child: KoreanCrown(size: 78)),
          Text('어느 왕의 지혜를\n빌리시겠습니까?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          const Text('왕마다 다른 분위기로 의견을 작성해 보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: KingColors.muted, height: 1.6)),
          const SizedBox(height: 24),
          for (final king in KingPersona.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      button: true,
                      label: '${king.title} 선택',
                      child: Material(
                        color: king.paper,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: king.color.withValues(alpha: .5)),
                            borderRadius: BorderRadius.circular(6)),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => onSelected(king),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(children: [
                              Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      color: king.color,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Icon(king.icon,
                                      color: KingColors.goldLight, size: 30)),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(king.title,
                                        style: TextStyle(
                                            color: king.color,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 5),
                                    Text(king.subtitle,
                                        style: const TextStyle(fontSize: 13)),
                                    const SizedBox(height: 8),
                                    Text(king.traits,
                                        style: TextStyle(
                                            color: king.color, fontSize: 11)),
                                  ])),
                              Icon(Icons.chevron_right, color: king.color),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (_) => PersonaOpinionPreviewScreen(
                                      persona: king))),
                          icon: const Icon(Icons.visibility_outlined, size: 17),
                          label: Text('${king.title} 의견지 미리보기'),
                        )),
                  ]),
            ),
        ]),
      );
}

/// Local design preview; never authenticates, creates rooms, or submits opinions.
class PersonaOpinionPreviewScreen extends StatelessWidget {
  const PersonaOpinionPreviewScreen({required this.persona, super.key});
  final KingPersona persona;
  @override
  Widget build(BuildContext context) => RoyalScaffold(
        title: '${persona.title} · 의견지',
        kicker: '디자인 미리보기',
        child: ListView(padding: const EdgeInsets.all(24), children: [
          PersonaBanner(persona: persona),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                color: persona.paper,
                border:
                    Border.all(color: persona.color.withValues(alpha: .35))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PersonaWritingHeading(persona: persona),
                  const SizedBox(height: 20),
                  TextField(
                      minLines: 5,
                      maxLines: 8,
                      maxLength: 300,
                      decoration: InputDecoration(hintText: persona.hint)),
                  const SizedBox(height: 16),
                  const RoyalButton(label: '의견 봉인하기'),
                  const SizedBox(height: 12),
                  const Text('미리보기에서는 의견을 전송하지 않습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: KingColors.muted)),
                ]),
          ),
        ]),
      );
}
