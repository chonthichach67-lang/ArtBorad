import 'package:flutter/material.dart';

import '../core/theme.dart';

/// หัวข้อส่วน (แถบสีหน้าหัวข้อ + trailing ด้านขวา)
class Sec extends StatelessWidget {
  final String t;
  final Widget? trailing;
  const Sec(this.t, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
        child: Row(children: [
          Container(width: 5, height: 18, decoration: BoxDecoration(color: acc, borderRadius: BorderRadius.circular(2), border: Border.all(color: ink, width: 1.2))),
          const SizedBox(width: 10),
          Expanded(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
          if (trailing != null) trailing!,
        ]),
      );
}
