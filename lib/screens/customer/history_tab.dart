import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../state/app_state.dart';
import '../../widgets/ui_helpers.dart';
import 'book_page.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.i.bookings.where((b) => b.u == S.i.me).toList().reversed.toList();
    if (l.isEmpty) return emptyState(Icons.event_busy_outlined, 'ยังไม่มีประวัติการจอง');
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      for (final b in l)
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text('#${b.id} ${b.g.name}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800))),
            const SizedBox(width: 8),
            pill(b.status, b.status == 'ยกเลิก' ? badC : okC),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 6, children: [
            chip(Icons.calendar_month, fmtD(b.date)),
            chip(Icons.schedule, fmtT(b.start, b.hours), violet),
            chip(Icons.table_restaurant, 'โต๊ะ ${b.table} · ${b.ppl} คน', acc),
          ]),
          const SizedBox(height: 8),
          Text('${b.price} บาท • +${b.earn} แต้ม', style: const TextStyle(color: goldDk, fontWeight: FontWeight.w800)),
          if (b.status != 'ยกเลิก')
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(b.g, edit: b))), child: const Text('แก้ไข')),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (d) => AlertDialog(
                    backgroundColor: cardC,
                    shape: dlgShape,
                    title: const Text('ยกเลิกการจอง?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(d), child: const Text('ไม่')),
                      FilledButton(
                        onPressed: () {
                          S.i.cancel(b);
                          Navigator.pop(d);
                        },
                        child: const Text('ยกเลิกการจอง'),
                      )
                    ],
                  ),
                ),
                child: const Text('ยกเลิก', style: TextStyle(color: badC)),
              ),
            ]),
        ])),
    ]);
  }
}
