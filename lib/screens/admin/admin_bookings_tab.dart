import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../state/app_state.dart';
import '../../widgets/neon.dart';
import '../../widgets/section_title.dart';
import '../../widgets/ui_helpers.dart';

/// แท็บคิวจองทั้งหมด (แอดมิน)
/// หมายเหตุ: ตั้งใจ "ไม่" ทำ constructor เป็น const เพื่อให้ถูกสร้างใหม่ทุกครั้งที่ S แจ้งเปลี่ยน
/// (ถ้าเป็น const Flutter จะข้ามการ rebuild แล้วหน้าจอไม่อัปเดต)
class AdminBookingsTab extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AdminBookingsTab({super.key});

  Widget _stat(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: neon(),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: txt2)),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final all = S.i.bookings;
    final active = all.where((b) => b.status != 'ยกเลิก').length;
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const Sec('คิวจองทั้งหมด'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Row(
            children: [
              _stat('ทั้งหมด', '${all.length}', acc2),
              const SizedBox(width: 8),
              _stat('จองอยู่', '$active', okC),
              const SizedBox(width: 8),
              _stat('ยกเลิก', '${all.length - active}', badC),
            ],
          ),
        ),
        if (all.isEmpty)
          emptyState(Icons.event_busy_outlined, 'ไม่มีรายการจอง'),
        for (final b in all.reversed)
          card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${b.id}  ${b.u.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(b.g.name, style: const TextStyle(color: txt2)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    chip(Icons.table_restaurant, 'โต๊ะ ${b.table}'),
                    chip(Icons.calendar_month, fmtD(b.date), violet),
                    chip(Icons.schedule, fmtT(b.start, b.hours), goldDk),
                    chip(Icons.group, '${b.ppl} คน', acc),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 112,
                          child: pill(
                            'สถานะ: ${b.status}',
                            b.status == 'ยกเลิก' ? badC : okC,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 55),
                    Text(
                      '${b.price} บาท',
                      style: const TextStyle(
                        color: goldDk,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (b.status == 'จองแล้ว')
                      IconButton(
                        tooltip: 'ยกเลิกการจอง',
                        icon: const Icon(Icons.cancel_outlined, color: badC),
                        onPressed: () => S.i.cancel(b),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
