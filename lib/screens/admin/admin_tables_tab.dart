import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/section_title.dart';
import '../../widgets/ui_helpers.dart';

/// แท็บแผนผังโต๊ะ (แอดมิน): แตะเพื่อปิด/เปิดโต๊ะ
/// หมายเหตุ: ตั้งใจ "ไม่" ทำ constructor เป็น const เพื่อให้ถูกสร้างใหม่ทุกครั้งที่ S แจ้งเปลี่ยน
/// (ถ้าเป็น const Flutter จะข้ามการ rebuild แล้วหน้าจอไม่อัปเดต)
class AdminTablesTab extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AdminTablesTab({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('แผนผังโต๊ะ (ตอนนี้) — แตะเพื่อปิด/เปิดโต๊ะ'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            for (int t = 1; t <= 3; t++) ...[
              if (t > 1) const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (S.i.closed.contains(t)) {
                      S.i.closed.remove(t);
                    } else {
                      S.i.closed.add(t);
                    }
                    S.i.notes.add('${S.i.closed.contains(t) ? "🔒 ปิด" : "🪑 เปิด"}โต๊ะ $t');
                    S.i.ping();
                  },
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 150),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    decoration: BoxDecoration(
                      color: S.i.closed.contains(t) ? offC : cardC,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: S.i.closed.contains(t) ? txt3 : acc2, width: 2.4),
                      boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.table_restaurant_rounded, size: 35, color: S.i.closed.contains(t) ? txt3 : acc2),
                      const SizedBox(height: 8),
                      Text('โต๊ะ $t', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 3),
                      Text(S.i.closed.contains(t) ? 'ปิดใช้งาน' : 'เปิดใช้งาน',
                          style: TextStyle(color: S.i.closed.contains(t) ? badC : okC, fontWeight: FontWeight.w700, fontSize: 12)),
                    ]),
                  ),
                ),
              ),
            ],
          ]),
        ),
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('สถานะการใช้งาน', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          for (int t = 1; t <= 3; t++)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.table_restaurant, color: S.i.closed.contains(t) ? badC : okC),
              title: Text('โต๊ะ $t'),
              subtitle: Text(S.i.closed.contains(t) ? 'ปิดรับจอง' : 'เปิดรับจอง'),
              value: !S.i.closed.contains(t),
              onChanged: (open) {
                if (open) { S.i.closed.remove(t); } else { S.i.closed.add(t); }
                S.i.ping();
              },
            ),
        ])),
      ]);
}
