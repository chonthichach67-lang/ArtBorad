import 'package:flutter/material.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';

class TablesAdmin extends StatelessWidget {
  const TablesAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView(padding: const EdgeInsets.all(8), children: [
      const Padding(padding: EdgeInsets.all(8), child: Text('แผนผังโต๊ะ (ตอนนี้) — แตะเพื่อปิด/เปิดโต๊ะ', style: TextStyle(color: Colors.white60))),
      GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(8),
          children: [
            for (final t in [1, 2, 3])
              Builder(builder: (_) {
                final closed = AppState.i.closed.contains(t);
                final busy = !closed && !AppState.i.free(t, now, now.hour, 1);
                final c = closed ? Colors.grey : busy ? Colors.redAccent : Colors.greenAccent;
                return InkWell(
                    onTap: () {
                      closed ? AppState.i.closed.remove(t) : AppState.i.closed.add(t);
                      AppState.i.ping();
                    },
                    child: Container(
                        decoration: neon(c: c, w: 2, a: .8),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.table_restaurant, color: c, size: 36),
                          const SizedBox(height: 6),
                          Text('โต๊ะ $t', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(closed ? 'ปิดใช้งาน' : busy ? 'ไม่ว่าง' : 'ว่าง', style: TextStyle(color: c, fontSize: 12)),
                        ])));
              })
          ]),
    ]);
  }
}
