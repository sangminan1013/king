import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/king_theme.dart';
import '../theme/king_persona.dart';

/// Code-drawn ornament: no network images, packages, or runtime downloads.
class KoreanCrown extends StatelessWidget {
  const KoreanCrown({this.size = 100, this.color = KingColors.gold, super.key});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => Semantics(
        label: '한국 전통 금관을 재해석한 왕관',
        image: true,
        child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(painter: _CrownPainter(color))),
      );
}

class _CrownPainter extends CustomPainter {
  const _CrownPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 100, size.height / 100);
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = color.withValues(alpha: .14);
    final band = RRect.fromRectAndRadius(
        const Rect.fromLTWH(17, 65, 66, 16), const Radius.circular(3));
    canvas.drawRRect(band, fill);
    canvas.drawRRect(band, line);
    // Upright tree branches inspired by Korean gold crowns.
    for (final x in [29.0, 50.0, 71.0]) {
      final top = x == 50 ? 14.0 : 27.0;
      canvas.drawLine(Offset(x, 64), Offset(x, top), line);
      for (final y in [top + 10, top + 24]) {
        canvas.drawPath(
            Path()
              ..moveTo(x - 8, y - 7)
              ..lineTo(x - 8, y)
              ..lineTo(x, y + 5)
              ..lineTo(x + 8, y)
              ..lineTo(x + 8, y - 7),
            line);
      }
      canvas.drawCircle(Offset(x, top), 3, Paint()..color = color);
    }
    for (final x in [10.0, 90.0]) {
      canvas.drawLine(Offset(x, 49), Offset(x, 78), line);
      canvas.drawOval(
          Rect.fromCenter(center: Offset(x, 83), width: 5, height: 10), line);
      canvas.drawLine(Offset(x, 49), Offset(x < 50 ? 20 : 80, 61), line);
    }
    for (final x in [28.0, 50.0, 72.0]) {
      canvas.drawCircle(Offset(x, 73), 2, Paint()..color = color);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CrownPainter old) => color != old.color;
}

class TraditionalPattern extends CustomPainter {
  const TraditionalPattern();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = KingColors.gold.withValues(alpha: .09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    for (double y = 8; y < size.height; y += 76) {
      for (double x = 0; x < size.width; x += 76) {
        canvas.save();
        canvas.translate(x, y);
        for (var i = 0; i < 4; i++) {
          canvas.rotate(math.pi / 2);
          canvas.drawPath(
              Path()
                ..moveTo(0, 0)
                ..lineTo(23, 0)
                ..lineTo(23, 16)
                ..lineTo(9, 16)
                ..lineTo(9, 8)
                ..lineTo(16, 8),
              paint);
        }
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(TraditionalPattern old) => false;
}

class PersonaBanner extends StatelessWidget {
  const PersonaBanner({required this.persona, super.key});
  final KingPersona persona;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: persona.color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: KingColors.gold),
        ),
        child: CustomPaint(
            painter: _PersonaScene(persona),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                KoreanCrown(size: 60, color: KingColors.goldLight),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(persona.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold)),
                      Text(persona.traits,
                          style: const TextStyle(
                              color: Color(0xFFE6D4AC), fontSize: 12)),
                    ])),
                Icon(persona.icon, color: KingColors.goldLight, size: 28),
              ]),
              const SizedBox(height: 16),
              Text('“${persona.quote}”',
                  style: const TextStyle(
                      color: Color(0xFFFFF7E7), fontSize: 17, height: 1.6)),
              const SizedBox(height: 12),
              Text(persona.scene,
                  style:
                      const TextStyle(color: Color(0xFFE6D4AC), fontSize: 11)),
            ])),
      );
}

class PersonaWritingHeading extends StatelessWidget {
  const PersonaWritingHeading({required this.persona, super.key});
  final KingPersona persona;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(persona.icon, color: persona.color, size: 28),
          const SizedBox(height: 10),
          Text(persona.writingTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: persona.color)),
          const SizedBox(height: 6),
          Text(persona.hint, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}

class _PersonaScene extends CustomPainter {
  const _PersonaScene(this.persona);
  final KingPersona persona;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFD9B970).withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final x = size.width * .73;
    final y = size.height * .55;
    switch (persona) {
      case KingPersona.wise:
        // Folding screen with mountain silhouettes.
        for (var i = 0; i < 5; i++) {
          canvas.drawRect(
              Rect.fromLTWH(size.width * i / 5, 0, size.width / 5, size.height),
              p);
        }
        canvas.drawPath(
            Path()
              ..moveTo(0, size.height)
              ..lineTo(size.width * .2, size.height * .4)
              ..lineTo(size.width * .4, size.height * .8)
              ..lineTo(size.width * .6, size.height * .25)
              ..lineTo(size.width, size.height),
            p);
      case KingPersona.iron:
        for (var i = 0; i < 6; i++) {
          final top = i * 28.0;
          canvas.drawPath(
              Path()
                ..moveTo(size.width * .5, top)
                ..lineTo(size.width * .75, top + 30)
                ..lineTo(size.width, top),
              p);
        }
      case KingPersona.festive:
        for (var i = 0; i < 4; i++) {
          final dx = size.width * (i + .5) / 4;
          canvas.drawLine(Offset(dx, 0), Offset(dx, 28), p);
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTWH(dx - 14, 28, 28, 38), const Radius.circular(9)),
              p);
          canvas.drawLine(Offset(dx, 66), Offset(dx, 80), p);
        }
      case KingPersona.tender:
        canvas.drawCircle(Offset(x, 34), 24, p);
        for (var i = -2; i <= 2; i++) {
          canvas.save();
          canvas.translate(x, y + 30);
          canvas.rotate(i * .42);
          canvas.drawOval(const Rect.fromLTWH(-10, -38, 20, 46), p);
          canvas.restore();
        }
        canvas.drawPath(
            Path()
              ..moveTo(0, size.height)
              ..quadraticBezierTo(
                  size.width * .3, 20, size.width * .6, size.height)
              ..quadraticBezierTo(size.width * .8, 40, size.width, size.height),
            p);
      case KingPersona.tyrant:
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(.12);
        canvas.drawRect(
            const Rect.fromLTWH(-36, -36, 72, 72), p..strokeWidth = 4);
        canvas.drawRect(
            const Rect.fromLTWH(-28, -28, 56, 56), p..strokeWidth = 1);
        canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_PersonaScene old) => old.persona != persona;
}
