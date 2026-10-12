import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';

/// กรอบการ์ดสไตล์ HUD: ไล่เฉดน้ำเงินเข้ม + ขอบนีออน + เรืองแสง
BoxDecoration neon({Color c = acc, double w = 1, double a = .25}) => BoxDecoration(
    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F1A2E), Color(0xFF080C16)]),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: c.withOpacity(a), width: w),
    boxShadow: [BoxShadow(color: c.withOpacity(a * .35), blurRadius: 14)]);

Widget card(Widget c, {EdgeInsets m = const EdgeInsets.symmetric(horizontal: 16, vertical: 6)}) => Container(
    margin: m,
    padding: const EdgeInsets.all(14),
    decoration: neon(),
    child: c);

Widget chip(IconData i, String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: const Color(0x1400E5FF), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0x4400E5FF))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 14, color: acc), const SizedBox(width: 5), Text(t, style: const TextStyle(fontSize: 12))]));
