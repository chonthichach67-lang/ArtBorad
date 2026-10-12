import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';

/// พื้นหลังแอป: เรืองแสงมุมบน + เส้นกริดจางๆ
class TechBg extends StatelessWidget {
  final Widget child;
  const TechBg({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
        Container(decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment(.9, -1), radius: 1.4, colors: [Color(0xFF0A2236), bg, Color(0xFF020309)], stops: [0, .55, 1]))),
        CustomPaint(painter: _Grid()),
        child,
      ]);
}

class _Grid extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = const Color(0x1000E5FF)..strokeWidth = 1;
    for (double x = 0; x < s.width; x += 32) c.drawLine(Offset(x, 0), Offset(x, s.height), p);
    for (double y = 0; y < s.height; y += 32) c.drawLine(Offset(0, y), Offset(s.width, y), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
