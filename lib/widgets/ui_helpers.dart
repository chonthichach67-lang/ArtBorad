import 'package:flutter/material.dart';

import '../core/theme.dart';
import 'neon.dart';

/// การ์ดกลาง: onTap เป็น optional
Widget card(Widget c, {EdgeInsets m = const EdgeInsets.symmetric(horizontal: 16, vertical: 6), VoidCallback? onTap}) => Container(
      margin: m,
      decoration: neon(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(14), child: c),
        ),
      ),
    );

Widget chip(IconData i, String t, [Color c = acc2]) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: al(c, .14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: al(c, .7), width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(i, size: 14, color: c),
          const SizedBox(width: 5),
          Flexible(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );

Widget pill(String t, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: al(c, .16), borderRadius: BorderRadius.circular(20), border: Border.all(color: al(c, .8), width: 1.4)),
      child: Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
    );

Widget emptyState(IconData i, String t) => Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(i, size: 52, color: txt3),
          const SizedBox(height: 12),
          Text(t, textAlign: TextAlign.center, style: const TextStyle(color: txt2)),
        ]),
      ),
    );
