import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../models/booking.dart';
import '../../state/app_state.dart';
import '../../widgets/neon.dart';
import '../../widgets/ui_helpers.dart';

class Summary extends StatelessWidget {
  final B b;
  final B? old;
  const Summary(this.b, this.old, {super.key});

  Widget row(String a, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(a, style: const TextStyle(color: txt2)),
            const SizedBox(width: 16),
            Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final o = old;
    final after = b.u.pts + (o != null && o.status != 'ยกเลิก' ? o.used * 15 - o.earn : 0) + b.earn - b.used * 15;
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปการจอง')),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        card(Column(children: [
          row('บอร์ดเกม', b.g.name),
          row('จำนวนผู้เล่น', '${b.ppl} คน'),
          row('วันที่', fmtD(b.date)),
          row('เวลา', fmtT(b.start, b.hours)),
          row('จำนวนชั่วโมง', b.full ? 'เหมาวัน' : '${b.hours} ชม.'),
          row('โต๊ะ', 'โต๊ะ ${b.table}'),
          if (b.used > 0) row('ส่วนลดแลกแต้ม', '-35 บาท'),
          const Divider(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Expanded(child: Text('ราคาที่ต้องชำระ', style: TextStyle(fontWeight: FontWeight.w700))),
            Text('${b.price} บาท', style: const TextStyle(color: goldDk, fontSize: 22, fontWeight: FontWeight.w900)),
          ]),
          row('แต้มที่จะได้รับ', '+${b.earn} แต้ม'),
        ])),
        card(Row(children: [
          const Icon(Icons.toll_rounded, color: goldDk, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('คุณจะได้รับ +${b.earn} แต้ม', style: const TextStyle(color: goldDk, fontSize: 19, fontWeight: FontWeight.w900)),
              Text('(${b.price} บาท ÷ 35 = ${b.earn} แต้ม)', style: const TextStyle(color: txt2, fontSize: 12)),
              if (b.used > 0) const Text('ใช้แต้มแลกฟรี 1 ชม.: -15 แต้ม', style: TextStyle(color: txt2, fontSize: 12)),
              const SizedBox(height: 2),
              Text('แต้มสะสมหลังจองเสร็จ: $after แต้ม', style: const TextStyle(fontSize: 13)),
            ]),
          ),
        ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 19, 16),
          child: SizedBox(
            height: 54,
            child: hard(FilledButton(
              onPressed: () {
                final m = ScaffoldMessenger.of(context);
                S.i.save(b, old);
                Navigator.popUntil(context, (r) => r.isFirst);
                m.showSnackBar(SnackBar(content: Text('บันทึกการจองแล้ว ได้รับ ${b.earn} แต้ม')));
              },
              child: const Text('ยืนยันการจอง'),
            )),
          ),
        ),
      ]),
    );
  }
}
