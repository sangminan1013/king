import "dart:math" as math;

import "package:flutter/material.dart";

import "../theme/king_theme.dart";

enum CourtMotif { paper, eave, landscape, seal, portrait }

class CourtArt extends StatelessWidget {
  const CourtArt(this.motif, {this.portraitVariant = 0, super.key});

  final CourtMotif motif;
  final int portraitVariant;

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: CustomPaint(
          painter: _CourtPainter(motif, portraitVariant),
          child: const SizedBox.expand(),
        ),
      );
}

class _CourtPainter extends CustomPainter {
  const _CourtPainter(this.motif, this.variant);

  final CourtMotif motif;
  final int variant;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    switch (motif) {
      case CourtMotif.paper:
        _paper(canvas, size);
      case CourtMotif.eave:
        _eave(canvas, size);
      case CourtMotif.landscape:
        _landscape(canvas, size);
      case CourtMotif.seal:
        _seal(canvas, size);
      case CourtMotif.portrait:
        _portrait(canvas, size);
    }
  }

  Paint _fill(Color color) => Paint()..color = color;

  Paint _stroke(Color color, [double width = 1]) => Paint()
    ..color = color
    ..strokeWidth = width
    ..style = PaintingStyle.stroke;

  void _paper(Canvas canvas, Size size) {
    final random = math.Random(1357);
    final fiber = _stroke(KingColors.brown.withValues(alpha: .10), .5);
    for (var i = 0; i < (size.width * size.height / 430).clamp(1, 2100); i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawLine(
          Offset(x, y),
          Offset(x + 1 + random.nextDouble() * 5, y + random.nextDouble() * 2),
          fiber);
    }
    final corner = _stroke(KingColors.gold.withValues(alpha: .36));
    for (final x in [12.0, size.width - 12]) {
      final direction = x < size.width / 2 ? 1 : -1;
      for (final y in [20.0, size.height - 20]) {
        final rise = y < size.height / 2 ? 1 : -1;
        for (var i = 0; i < 3; i++) {
          final length = 36.0 - i * 9;
          final origin = Offset(x + direction * i * 5, y + rise * i * 5);
          canvas.drawPath(
              Path()
                ..moveTo(origin.dx + direction * length, origin.dy)
                ..lineTo(origin.dx, origin.dy)
                ..lineTo(origin.dx, origin.dy + rise * length),
              corner);
        }
      }
    }
    _sideOrnaments(canvas, size);
  }

  void _sideOrnaments(Canvas canvas, Size size) {
    const spacing = 64.0;
    final inset = (size.width - 620).clamp(0.0, 224.0) * .25 + 14;
    final gold = _stroke(KingColors.gold.withValues(alpha: .24));
    final green = _stroke(KingColors.green.withValues(alpha: .17));
    final lattice = Path()
      ..moveTo(0, -13)
      ..lineTo(9, 0)
      ..lineTo(0, 13)
      ..lineTo(-9, 0)
      ..close();
    final lotus = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-3, -3, 0, -7)
      ..quadraticBezierTo(3, -3, 0, 0)
      ..quadraticBezierTo(3, -4, 6, -3)
      ..quadraticBezierTo(5, 1, 0, 0)
      ..quadraticBezierTo(4, 2, 5, 5)
      ..quadraticBezierTo(2, 5, 0, 0)
      ..quadraticBezierTo(-2, 5, -5, 5)
      ..quadraticBezierTo(-4, 2, 0, 0)
      ..quadraticBezierTo(-5, 1, -6, -3)
      ..quadraticBezierTo(-3, -4, 0, 0)
      ..close();

    for (final x in [inset, size.width - inset]) {
      for (var y = 96.0; y < size.height - 68; y += spacing) {
        canvas.save();
        canvas.translate(x, y);
        canvas.drawPath(lattice, gold);
        canvas.drawPath(lotus, green);
        canvas.drawLine(const Offset(0, 16), const Offset(0, 30), gold);
        canvas.drawLine(const Offset(0, -30), const Offset(0, -16), gold);
        canvas.restore();
      }
    }
  }

  void _eave(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;
    canvas.drawRect(Offset.zero & size, _fill(KingColors.green));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * .22), _fill(KingColors.brown));
    canvas.drawRect(
        Rect.fromLTWH(0, h * .75, w, h * .25), _fill(KingColors.burgundyDark));
    for (var x = 8.0; x < w + 10; x += 19) {
      final point = Offset(x, h * .49);
      canvas.drawPath(
          Path()
            ..moveTo(x - 7, point.dy)
            ..lineTo(x, point.dy - h * .24)
            ..lineTo(x + 7, point.dy)
            ..lineTo(x, point.dy + h * .24)
            ..close(),
          _stroke(KingColors.goldLight, .9));
      canvas.drawCircle(point, h * .09, _fill(KingColors.paperDeep));
    }
    canvas.drawLine(
        Offset(0, h - .5), Offset(w, h - .5), _stroke(KingColors.goldLight));
  }

  void _landscape(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 520, size.height / 150);
    final mountain = Path()
      ..moveTo(0, 100)
      ..cubicTo(46, 95, 71, 36, 119, 53)
      ..cubicTo(136, 59, 141, 78, 159, 74)
      ..cubicTo(179, 67, 196, 26, 229, 44)
      ..cubicTo(269, 61, 287, 113, 330, 81)
      ..cubicTo(363, 57, 366, 27, 414, 43)
      ..cubicTo(466, 60, 464, 98, 520, 85)
      ..lineTo(520, 150)
      ..lineTo(0, 150)
      ..close();
    canvas.drawPath(mountain, _fill(KingColors.mist.withValues(alpha: .60)));
    final ridge = Path()
      ..moveTo(0, 125)
      ..cubicTo(59, 131, 76, 91, 115, 99)
      ..cubicTo(157, 107, 165, 133, 223, 109)
      ..cubicTo(255, 94, 293, 130, 339, 106)
      ..cubicTo(400, 80, 439, 103, 463, 104)
      ..quadraticBezierTo(483, 101, 520, 118)
      ..lineTo(520, 150)
      ..lineTo(0, 150)
      ..close();
    canvas.drawPath(ridge, _fill(KingColors.green.withValues(alpha: .20)));
    final cloud = _stroke(KingColors.muted.withValues(alpha: .35), 1.1);
    for (final origin in [
      const Offset(104, 39),
      const Offset(338, 60),
      const Offset(49, 83)
    ]) {
      canvas.drawPath(
          Path()
            ..moveTo(origin.dx, origin.dy)
            ..relativeLineTo(19, 0)
            ..relativeCubicTo(5, 0, 5, -6, 11, -6)
            ..relativeLineTo(17, 0)
            ..relativeCubicTo(6, 0, 6, 6, 11, 6)
            ..relativeLineTo(12, 0),
          cloud);
    }
    _palace(canvas, 104, 109, .51);
    _palace(canvas, 412, 110, .53);
    _palace(canvas, 260, 105, 1);
    canvas.restore();
  }

  void _palace(Canvas canvas, double x, double y, double scale) {
    canvas.save();
    canvas.translate(x, y);
    canvas.scale(scale);
    final roof = Path()
      ..moveTo(-89, -27)
      ..quadraticBezierTo(-63, -25, -39, -44)
      ..quadraticBezierTo(-25, -62, 0, -52)
      ..quadraticBezierTo(23, -62, 39, -44)
      ..quadraticBezierTo(68, -24, 89, -27)
      ..quadraticBezierTo(78, -13, 53, -15)
      ..lineTo(-53, -15)
      ..quadraticBezierTo(-78, -13, -89, -27)
      ..close();
    canvas.drawRect(
        const Rect.fromLTWH(-65, -17, 130, 39), _fill(KingColors.brown));
    canvas.drawRect(
        const Rect.fromLTWH(-69, -16, 138, 8), _fill(KingColors.green));
    for (final pillar in [-53.0, -29.0, 0.0, 29.0, 53.0]) {
      canvas.drawRect(
          Rect.fromLTWH(pillar - 3, -9, 6, 30), _fill(KingColors.burgundy));
      canvas.drawLine(Offset(pillar + 3, -8), Offset(pillar + 3, 20),
          _stroke(KingColors.gold, .8));
    }
    canvas.drawPath(roof, _fill(KingColors.ink));
    canvas.drawPath(
        Path()
          ..moveTo(-81, -24)
          ..quadraticBezierTo(-59, -15, 0, -20)
          ..quadraticBezierTo(58, -15, 81, -24),
        _stroke(KingColors.goldLight, 1.1));
    for (var x = -54.0; x <= 54; x += 9) {
      final y = -46 + x.abs() * .30;
      canvas.drawLine(Offset(x * .72, y), Offset(x, -21),
          _stroke(KingColors.paper.withValues(alpha: .30), .7));
    }
    canvas.drawRect(
        const Rect.fromLTWH(-73, 21, 146, 4), _fill(KingColors.muted));
    canvas.drawRect(
        const Rect.fromLTWH(-81, 25, 162, 3), _fill(KingColors.brown));
    canvas.restore();
  }

  void _seal(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 40, size.height / 40);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(1, 1, 38, 38), const Radius.circular(4)),
        _fill(KingColors.burgundy));
    final line = _stroke(KingColors.paperLight, 1.3);
    canvas.drawRect(const Rect.fromLTWH(5, 5, 30, 30), line);
    for (final origin in [
      const Offset(10, 10),
      const Offset(23, 10),
      const Offset(10, 23),
      const Offset(23, 23)
    ]) {
      canvas.drawPath(
          Path()
            ..moveTo(origin.dx, origin.dy + 7)
            ..relativeLineTo(0, -7)
            ..relativeLineTo(7, 0)
            ..relativeLineTo(0, 7)
            ..relativeLineTo(-3.5, 0)
            ..relativeLineTo(0, -3.5),
          line);
    }
    canvas.restore();
  }

  void _portrait(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 80, size.height / 92);
    const robes = [
      KingColors.burgundy,
      KingColors.green,
      KingColors.burgundy,
      KingColors.muted,
      KingColors.burgundyDark
    ];
    canvas.drawRect(
        const Rect.fromLTWH(0, 0, 80, 92), _fill(KingColors.paperDeep));
    canvas.drawOval(
        const Rect.fromLTWH(10, 9, 60, 67), _stroke(KingColors.gold));
    canvas.drawPath(
        Path()
          ..moveTo(8, 90)
          ..quadraticBezierTo(10, 67, 30, 64)
          ..lineTo(50, 64)
          ..quadraticBezierTo(70, 67, 72, 90)
          ..close(),
        _fill(robes[variant]));
    canvas.drawOval(
        const Rect.fromLTWH(28, 32, 24, 32), _fill(KingColors.portraitSkin));
    canvas.drawPath(
        Path()
          ..moveTo(28, 40)
          ..lineTo(26, 24)
          ..quadraticBezierTo(18, 23, 13, 14)
          ..quadraticBezierTo(26, 13, 31, 23)
          ..quadraticBezierTo(40, 17, 49, 23)
          ..quadraticBezierTo(54, 13, 67, 14)
          ..quadraticBezierTo(63, 22, 54, 24)
          ..lineTo(52, 40)
          ..quadraticBezierTo(40, 35, 28, 40)
          ..close(),
        _fill(KingColors.ink));
    final line = _stroke(KingColors.brown, 1.15);
    canvas.drawLine(const Offset(33, 46), const Offset(37, 45), line);
    canvas.drawLine(const Offset(43, 45), const Offset(47, 46), line);
    canvas.drawPath(
        Path()
          ..moveTo(34, 56)
          ..quadraticBezierTo(40, 53, 46, 56)
          ..quadraticBezierTo(45, 68, 40, 70)
          ..quadraticBezierTo(35, 67, 34, 56),
        _fill(KingColors.ink));
    canvas.drawPath(
        Path()
          ..moveTo(27, 67)
          ..lineTo(40, 76)
          ..lineTo(53, 67),
        _stroke(KingColors.paperLight, 1.5));
    canvas.drawCircle(
        const Offset(40, 81), 5, _stroke(KingColors.goldLight, 1.1));
    canvas.drawRect(
        const Rect.fromLTWH(1, 1, 78, 90), _stroke(KingColors.gold, 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CourtPainter oldDelegate) =>
      oldDelegate.motif != motif || oldDelegate.variant != variant;
}
