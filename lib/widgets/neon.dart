import 'package:flutter/material.dart';

import '../core/theme.dart';

/// กรอบการ์ดมาตรฐานของแอป (ขอบหนา + เงาแข็ง)
BoxDecoration neon({Color fill = cardC, Color border = lineC, double w = 2.2, double r = 16}) => BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: border, width: w),
      boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))],
    );

/// กล่องกดได้สไตล์ neo (ใช้ทำปุ่ม, ชิปวันที่, ชิปเวลา ฯลฯ)
Widget nb(Widget child,
        {Color fill = cardC, VoidCallback? onTap, double r = 12, EdgeInsets pad = EdgeInsets.zero, bool shadow = true}) =>
    Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: ink, width: 2.2),
        boxShadow: shadow ? const [BoxShadow(color: shd, offset: Offset(3, 3))] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(r),
        child: InkWell(borderRadius: BorderRadius.circular(r), onTap: onTap, child: Padding(padding: pad, child: child)),
      ),
    );

/// ใส่เงาแข็งให้ปุ่ม Material
Widget hard(Widget child, {double r = 14}) => Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(r), boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))]),
      child: child,
    );
