import 'package:flutter/material.dart';

/// เส้นประรอบกล่อง (ใช้กับโต๊ะที่ไม่ว่าง)
class DashedRRect extends CustomPainter {
  final Color c;
  const DashedRRect(this.c);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(1.25, 1.25, s.width - 2.5, s.height - 2.5), const Radius.circular(14)));
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 6), p);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRRect o) => o.c != c;
}
