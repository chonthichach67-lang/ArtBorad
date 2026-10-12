import 'package:flutter/material.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';

class QueueAdmin extends StatelessWidget {
  const QueueAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppState.i.bookings.reversed.toList();
    if (l.isEmpty) return const Center(child: Text('ยังไม่มีคิวการจอง'));
    return ListView(children: [
      for (final b in l)
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text('#${b.id} ${b.u.name} — ${b.g.name}', style: const TextStyle(fontWeight: FontWeight.bold))),
            Text(b.status, style: TextStyle(color: b.status == 'ยกเลิก' ? Colors.redAccent : Colors.greenAccent))
          ]),
          const SizedBox(height: 6),
          Text('${fmtD(b.date)}  ${fmtT(b.start, b.hours)}  • โต๊ะ ${b.table} (${b.ppl} คน)'),
          Text('${b.price} บาท • โทร: ${b.u.phone}', style: const TextStyle(color: Colors.white60)),
          if (b.status != 'ยกเลิก')
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () => AppState.i.cancel(b),
                  child: const Text('ยกเลิกคิวนี้', style: TextStyle(color: Colors.redAccent))),
            )
        ]))
    ]);
  }
}
