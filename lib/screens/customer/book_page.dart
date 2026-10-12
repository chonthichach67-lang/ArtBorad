import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/models/board_game.dart';
import 'package:testtt/models/booking.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/game_card.dart';
import 'package:testtt/widgets/neon.dart';
import 'package:testtt/screens/customer/summary_page.dart';

class BookPage extends StatefulWidget {
  final BoardGame g;
  final Booking? edit;
  const BookPage(this.g, {super.key, this.edit});
  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late int ppl = widget.edit?.ppl ?? 2, start = widget.edit?.start ?? 18, hours = widget.edit?.hours ?? 2;
  late bool full = widget.edit?.full ?? false, redeem = (widget.edit?.used ?? 0) > 0;
  late DateTime date = widget.edit?.date ?? DateTime.now();
  int? table;

  int get s => full ? 10 : start;
  int get h => full ? 12 : hours;
  int get base => full ? 135 * ppl : 35 * hours * ppl;
  int get disc => redeem ? 35 : 0;
  int get avail {
    final e = widget.edit;
    return AppState.i.me!.pts + (e != null && e.status != 'ยกเลิก' ? e.used * 15 - e.earn : 0);
  }

  void fix() {
    if (table != null && !AppState.i.free(table!, date, s, h, widget.edit)) table = null;
    if (avail < 15) redeem = false;
    setState(() {});
  }

  Widget stepper(int v, int lo, int hi, ValueChanged<int> f, String unit) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: v > lo ? () => f(v - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
        Text('$v $unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(onPressed: v < hi ? () => f(v + 1) : null, icon: const Icon(Icons.add_circle_outline, color: acc)),
      ]);

  @override
  Widget build(BuildContext context) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final freeCount = [1, 2, 3].where((t) => AppState.i.free(t, date, s, h, widget.edit)).length;
    return Scaffold(
        appBar: AppBar(title: Text(widget.edit == null ? 'จองโต๊ะ' : 'แก้ไขการจอง #${widget.edit!.id}')),
        body: ListView(padding: const EdgeInsets.only(bottom: 30), children: [
          GameCard(widget.g),
          card(Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('จำนวนคน'), stepper(ppl, 1, 12, (v) { ppl = v; fix(); }, 'คน')]),
            SegmentedButton<bool>(
                segments: const [ButtonSegment(value: false, label: Text('รายชั่วโมง')), ButtonSegment(value: true, label: Text('เหมาทั้งวัน'))],
                selected: {full},
                onSelectionChanged: (v) { full = v.first; fix(); }),
          ])),
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('รายละเอียดราคา', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('• รายชั่วโมง 35 บาท / คน / ชั่วโมง', style: TextStyle(color: Colors.white70)),
            const Text('• เหมาวัน 135 บาท / คน', style: TextStyle(color: Colors.white70)),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('ราคาที่ต้องชำระ'),
              Text('${base - disc} บาท', style: const TextStyle(color: acc, fontSize: 20, fontWeight: FontWeight.w900))
            ]),
          ])),
          card(Column(children: [
            ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month, color: acc),
                title: const Text('วันที่'),
                trailing: Text(fmtD(date)),
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: date, firstDate: date.isBefore(today) ? date : today, lastDate: today.add(const Duration(days: 60)));
                  if (d != null) { date = d; fix(); }
                }),
            if (!full) ...[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Row(children: [Icon(Icons.schedule, color: acc), SizedBox(width: 12), Text('เวลาเริ่ม')]),
                DropdownButton<int>(value: start, items: [for (var t = 10; t < 22; t++) DropdownMenuItem(value: t, child: Text('${t.toString().padLeft(2, '0')}:00'))], onChanged: (v) { start = v!; if (start + hours > 22) hours = 22 - start; fix(); }),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('จำนวนชั่วโมง'), stepper(hours, 1, 22 - start, (v) { hours = v; fix(); }, 'ชม.')]),
            ] else
              const Text('เหมาวัน: 10:00-22:00', style: TextStyle(color: Colors.white60)),
          ])),
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: Text('โต๊ะที่ว่าง $freeCount / 3 โต๊ะ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          for (final t in [1, 2, 3])
            Builder(builder: (_) {
              final ok = AppState.i.free(t, date, s, h, widget.edit);
              return Opacity(
                  opacity: ok ? 1 : .4,
                  child: InkWell(
                      onTap: ok ? () => setState(() => table = t) : null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          padding: const EdgeInsets.all(14),
                          decoration: neon(w: table == t ? 2 : 1, a: table == t ? .9 : .18),
                          child: Row(children: [Icon(Icons.table_restaurant, color: ok ? Colors.greenAccent : Colors.redAccent), const SizedBox(width: 12), Text('โต๊ะ $t'), const Spacer(), Text(ok ? 'ว่าง' : 'ไม่ว่าง')]))));
            }),
          if (avail >= 15) card(SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('ใช้ 15 แต้ม แลกฟรี 1 ชั่วโมง (-35 บาท)'), subtitle: Text('แต้มคงเหลือ $avail'), value: redeem, onChanged: (v) { redeem = v; fix(); })),
          Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 50,
                  child: FilledButton(
                      onPressed: table == null
                          ? null
                          : () {
                              final b = Booking(u: AppState.i.me!, g: widget.g, ppl: ppl, full: full, date: date, start: s, hours: h, table: table!, price: base - disc, used: redeem ? 1 : 0);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => Summary(b, widget.edit)));
                            },
                      child: Text(table == null ? 'เลือกโต๊ะก่อนยืนยัน' : 'ยืนยัน → สรุปรายละเอียด')))),
        ]));
  }
}
