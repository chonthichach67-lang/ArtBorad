import 'package:flutter/material.dart';

import '../core/theme.dart';

/// พื้นหลังแอป: สีมืด + ลายจุด
class TechBg extends StatelessWidget {
  final Widget child;
  const TechBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: bg),
          CustomPaint(painter: _Grid()),
          child,
        ],
      );
}

class _Grid extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = const Color(0x0DFFFFFF);
    for (double x = 14; x < s.width; x += 26) {
      for (double y = 14; y < s.height; y += 26) {
        c.drawCircle(Offset(x, y), 1.1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
