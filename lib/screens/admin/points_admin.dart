import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';

class PointsAdmin extends StatelessWidget {
  const PointsAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final users = AppState.i.users.where((x) => !x.admin).toList();
    if (users.isEmpty) return const Center(child: Text('ยังไม่มีลูกค้าลงทะเบียน'));
    return ListView(children: [
      for (final u in users)
        card(ListTile(
          title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('แต้มสะสม: ${u.pts} แต้ม'),
          trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: acc),
              onPressed: () {
                u.pts += 1;
                AppState.i.ping();
                snack(context, 'เพิ่ม 1 แต้มให้ ${u.name} แล้ว');
              }),
        ))
    ]);
  }
}
