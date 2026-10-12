import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/models/booking.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';

class Summary extends StatelessWidget {
  final Booking b;
  final Booking? old;
  const Summary(this.b, this.old, {super.key});
  Widget row(String a, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(a, style: const TextStyle(color: Colors.white60)), Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600)))]));
  @override
  Widget build(BuildContext context) {
    final o = old;
    final after = b.u.pts + (o != null && o.status != 'ยกเลิก' ? o.used * 15 - o.earn : 0) + b.earn - b.used * 15;
    return Scaffold(
        appBar: AppBar(title: const Text('สรุปการจอง')),
        body: ListView(children: [
          card(Column(children: [
            row('บอร์ดเกม', b.g.name),
            row('จำนวนผู้เล่น', '${b.ppl} คน'),
            row('วันที่', fmtD(b.date)),
            row('เวลา', fmtT(b.start, b.hours)),
            row('จำนวนชั่วโมง', b.full ? 'เหมาวัน' : '${b.hours} ชม.'),
            row('โต๊ะ', 'โต๊ะ ${b.table}'),
            if (b.used > 0) row('ส่วนลดแลกแต้ม', '-35 บาท'),
            const Divider(),
            row('ราคาที่ต้องชำระ', '${b.price} บาท'),
            row('แต้มที่จะได้รับ', '+${b.earn} แต้ม'),
          ])),
          card(Row(children: [
            const Icon(Icons.stars, color: acc, size: 40),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('คุณจะได้รับ +${b.earn} แต้ม', style: const TextStyle(color: acc, fontSize: 20, fontWeight: FontWeight.w900)),
              Text('(${b.price} บาท ÷ 35 = ${b.earn} แต้ม)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              if (b.used > 0) const Text('ใช้แต้มแลกฟรี 1 ชม.: -15 แต้ม', style: TextStyle(color: Colors.white54, fontSize: 12)),
              Text('แต้มสะสมหลังจองเสร็จ: $after แต้ม', style: const TextStyle(fontSize: 13)),
            ])),
          ])),
          Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 50,
                  child: FilledButton(
                      onPressed: () {
                        final m = ScaffoldMessenger.of(context);
                        AppState.i.save(b, old);
                        Navigator.popUntil(context, (r) => r.isFirst);
                        m.showSnackBar(SnackBar(content: Text('บันทึกการจองแล้ว ได้รับ ${b.earn} แต้ม')));
                      },
                      child: const Text('ยืนยันการจอง')))),
        ]));
  }
}
