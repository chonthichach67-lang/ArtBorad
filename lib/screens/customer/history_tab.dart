import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';
import 'package:testtt/screens/customer/book_page.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppState.i.bookings.where((b) => b.u == AppState.i.me).toList().reversed.toList();
    if (l.isEmpty) return const Center(child: Text('ยังไม่มีประวัติการจอง'));
    return ListView(children: [
      for (final b in l)
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text('#${b.id} ${b.g.name}', style: const TextStyle(fontWeight: FontWeight.bold))), Text(b.status, style: TextStyle(color: b.status == 'ยกเลิก' ? Colors.redAccent : Colors.greenAccent))]),
          const SizedBox(height: 6),
          Text('${fmtD(b.date)}  ${fmtT(b.start, b.hours)}  • โต๊ะ ${b.table} ${b.ppl} คน'),
          Text('${b.price} บาท • +${b.earn} แต้ม', style: const TextStyle(color: acc)),
          if (b.status != 'ยกเลิก')
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(b.g, edit: b))), child: const Text('แก้ไข')),
              TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (d) => AlertDialog(title: const Text('ยกเลิกการจอง?'), actions: [
                            TextButton(onPressed: () => Navigator.pop(d), child: const Text('ไม่')),
                            FilledButton(onPressed: () { AppState.i.cancel(b); Navigator.pop(d); }, child: const Text('ยกเลิกการจอง'))
                          ])),
                  child: const Text('ยกเลิก', style: TextStyle(color: Colors.redAccent))),
            ]),
        ])),
    ]);
  }
}
