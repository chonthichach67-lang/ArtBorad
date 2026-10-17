import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../models/user.dart';
import '../../state/app_state.dart';
import '../../widgets/section_title.dart';
import '../../widgets/ui_helpers.dart';

/// แท็บแต้มสะสมลูกค้า (แอดมิน)
class AdminPointsTab extends StatelessWidget {
  final List<U> customers;
  const AdminPointsTab(this.customers, {super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('แต้มสะสมลูกค้า'),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text('กด + เพื่อเพิ่มแต้ม หรือ − เพื่อลดแต้ม', style: TextStyle(color: txt2, fontSize: 12.5)),
        ),
        for (final u in customers)
          card(Row(children: [
            const CircleAvatar(backgroundColor: sand, child: Icon(Icons.person, color: acc2)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 4),
              Text('แต้มสะสม: ${u.pts} แต้ม', style: const TextStyle(color: goldDk, fontWeight: FontWeight.w700)),
            ])),
            IconButton(tooltip: 'ลด 1 แต้ม', icon: const Icon(Icons.remove_circle_outline, color: violet),
              onPressed: () => u.pts > 0 ? S.i.adjustPts(u, -1) : snack(context, '${u.name} ไม่มีแต้มให้ลด')),
            IconButton(tooltip: 'เพิ่ม 1 แต้ม', icon: const Icon(Icons.add_circle, color: acc2),
              onPressed: () => S.i.adjustPts(u, 1)),
          ])),
      ]);
}
