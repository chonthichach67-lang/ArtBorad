import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../models/booking.dart';
import '../../models/game.dart';
import '../../state/app_state.dart';
import '../../widgets/dashed_rrect.dart';
import '../../widgets/game_card.dart';
import '../../widgets/neon.dart';
import '../../widgets/ui_helpers.dart';
import 'summary.dart';

class BookPage extends StatefulWidget {
  final Game g;
  final B? edit;
  const BookPage(this.g, {super.key, this.edit});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late int ppl = widget.edit?.ppl ?? 2, start = widget.edit?.start ?? 18, hours = widget.edit?.hours ?? 2;
  late bool full = widget.edit?.full ?? false, redeem = (widget.edit?.used ?? 0) > 0;
  late DateTime date = widget.edit?.date ?? DateTime.now();
  int? table;

  // รายการวัน: วันนี้ → +60 วัน (ถ้าแก้ไขการจองที่เป็นวันเก่า จะเริ่มจากวันนั้น)
  late final DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late final DateTime _first = date.isBefore(_today) ? DateTime(date.year, date.month, date.day) : _today;
  late final List<DateTime> days = () {
    final last = DateTime(_today.year, _today.month, _today.day + 60);
    final out = <DateTime>[];
    var d = _first;
    while (!d.isAfter(last)) {
      out.add(d);
      d = DateTime(d.year, d.month, d.day + 1);
    }
    return out;
  }();
  late final ScrollController dayCtrl = ScrollController(
    initialScrollOffset: () {
      final idx = days.indexWhere((d) => sameDay(d, date));
      return idx <= 0 ? 0.0 : idx * 68.0;
    }(),
  );

  @override
  void dispose() {
    dayCtrl.dispose();
    super.dispose();
  }

  int get s => full ? 10 : start;
  int get h => full ? 12 : hours;
  int get base => full ? 135 * ppl : 35 * hours * ppl;
  int get disc => redeem ? 35 : 0;
  int get avail {
    final e = widget.edit;
    return S.i.me!.pts + (e != null && e.status != 'ยกเลิก' ? e.used * 15 - e.earn : 0);
  }

  void fix() {
    if (table != null && !S.i.free(table!, date, s, h, widget.edit)) table = null;
    if (avail < 15) redeem = false;
    setState(() {});
  }

  // ── UI helpers ──
  Widget lbl(String t, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(children: [
          Expanded(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
          if (trailing != null) trailing,
        ]),
      );

  Widget sq(IconData i, VoidCallback? on) => SizedBox(
        width: 38,
        height: 38,
        child: nb(Center(child: Icon(i, size: 20, color: on == null ? txt3 : dk)), fill: on == null ? sand : gold, onTap: on, r: 10, shadow: on != null),
      );

  Widget stepper(int v, int lo, int hi, ValueChanged<int> f, String unit) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          sq(Icons.remove, v > lo ? () => f(v - 1) : null),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$v $unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
          sq(Icons.add, v < hi ? () => f(v + 1) : null),
        ],
      );

  Widget gamePill(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: dk, width: 1.5)),
        child: Text(t, style: const TextStyle(color: dk, fontSize: 12, fontWeight: FontWeight.w700)),
      );

  Widget gameHeader() => Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 19, 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: acc,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ink, width: 2.5),
          boxShadow: const [BoxShadow(color: shd, offset: Offset(4, 4))],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          GameImg(widget.g, size: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.g.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17, height: 1.2)),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                gamePill('${widget.g.min}-${widget.g.max} คน'),
                gamePill(widget.g.diff),
                gamePill('${widget.g.mins} นาที'),
              ]),
            ]),
          ),
        ]),
      );

  Widget dayChip(DateTime d) {
    const wd = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];
    final sel = sameDay(d, date);
    final tc = sel ? dk : fg;
    return SizedBox(
      width: 58,
      child: nb(
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${d.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: tc)),
              Text(wd[d.weekday - 1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tc)),
            ]),
          ),
        ),
        fill: sel ? gold : cardC,
        onTap: () {
          date = d;
          fix();
        },
        r: 14,
        pad: const EdgeInsets.symmetric(vertical: 6),
      ),
    );
  }

  Widget timeChip(int t) {
    final sel = start == t;
    return SizedBox(
      width: 78,
      height: 42,
      child: nb(
        Center(child: Text('${t.toString().padLeft(2, '0')}:00', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: sel ? dk : fg))),
        fill: sel ? gold : cardC,
        onTap: () {
          start = t;
          if (start + hours > 22) hours = 22 - start;
          fix();
        },
        r: 12,
      ),
    );
  }

  Widget tableTile(int t) {
    final isClosed = S.i.closed.contains(t);
    final ok = S.i.free(t, date, s, h, widget.edit);
    final sel = table == t;
    final fill = sel ? acc : (ok ? acc2 : offC);
    final tc = sel ? Colors.white : (ok ? dk : txt3);
    final status = sel ? 'เลือกแล้ว' : (isClosed ? 'ปิดใช้งาน' : (ok ? 'ว่าง' : 'ไม่ว่าง'));
    final r = BorderRadius.circular(14);
    Widget body = Container(
      constraints: const BoxConstraints(minHeight: 72),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: ok
          ? BoxDecoration(color: fill, borderRadius: r, border: Border.all(color: ink, width: 2.5), boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))])
          : BoxDecoration(color: fill, borderRadius: r),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('โต๊ะ $t', style: TextStyle(color: tc, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 2),
          Text(status, style: TextStyle(color: tc, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
    if (!ok) body = CustomPaint(foregroundPainter: const DashedRRect(txt3), child: body);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (ok) {
          setState(() => table = t);
        } else {
          snack(context, isClosed ? 'โต๊ะ $t ปิดใช้งานอยู่' : 'โต๊ะ $t ไม่ว่างในช่วงเวลานี้ กรุณาเลือกโต๊ะหรือเวลาอื่น');
        }
      },
      child: body,
    );
  }

  Widget legendItem(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3), border: Border.all(color: ink, width: 2)),
        ),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
      ]);

  @override
  Widget build(BuildContext context) {
    final freeCount = [1, 2, 3].where((t) => S.i.free(t, date, s, h, widget.edit)).length;
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.only(bottom: 30), children: [
          // ── หัวข้อ + ปุ่มย้อนกลับ ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(children: [
              SizedBox(
                width: 44,
                height: 44,
                child: nb(const Center(child: Icon(Icons.arrow_back_ios_new_rounded, size: 18)), onTap: () => Navigator.maybePop(context), r: 12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(widget.edit == null ? 'จองโต๊ะ' : 'แก้ไขการจอง #${widget.edit!.id}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              ),
            ]),
          ),
          gameHeader(),

          // ── ผู้เล่นและรูปแบบเวลา ──
          lbl('ผู้เล่นและรูปแบบเวลา'),
          card(Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('จำนวนคน', style: TextStyle(fontWeight: FontWeight.w700)),
              stepper(ppl, 1, 12, (v) {
                ppl = v;
                fix();
              }, 'คน'),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [ButtonSegment(value: false, label: Text('รายชั่วโมง')), ButtonSegment(value: true, label: Text('เหมาทั้งวัน'))],
                selected: {full},
                onSelectionChanged: (v) {
                  full = v.first;
                  fix();
                },
              ),
            ),
          ])),

          // ── วันที่ ──
          lbl('วันที่', trailing: Text(fmtD(date), style: const TextStyle(color: txt2, fontWeight: FontWeight.w700))),
          SizedBox(
            height: 76,
            child: ListView.separated(
              controller: dayCtrl,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => dayChip(days[i]),
            ),
          ),

          // ── เวลา ──
          lbl('เวลา'),
          if (!full) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 19, 4),
              child: Wrap(spacing: 10, runSpacing: 12, children: [for (var t = 10; t < 22; t++) timeChip(t)]),
            ),
            card(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('จำนวนชั่วโมง', style: TextStyle(fontWeight: FontWeight.w700)),
              stepper(hours, 1, 22 - start, (v) {
                hours = v;
                fix();
              }, 'ชม.'),
            ])),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text('เวลาใช้โต๊ะ ${fmtT(start, hours)}', style: const TextStyle(color: txt2, fontSize: 12.5)),
            ),
          ] else
            card(const Row(children: [
              Icon(Icons.schedule, color: acc),
              SizedBox(width: 10),
              Expanded(child: Text('เหมาวัน: 10:00-22:00', style: TextStyle(fontWeight: FontWeight.w700))),
            ])),

          // ── เลือกโต๊ะ ──
          lbl('เลือกโต๊ะ', trailing: Text('โต๊ะที่ว่าง $freeCount / 3 โต๊ะ', style: const TextStyle(color: txt2, fontSize: 13))),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(12, 14, 15, 15),
            decoration: BoxDecoration(color: cardC, borderRadius: BorderRadius.circular(20), border: Border.all(color: ink, width: 2.5)),
            child: Row(children: [
              for (final t in [1, 2, 3]) ...[
                if (t > 1) const SizedBox(width: 12),
                Expanded(child: tableTile(t)),
              ],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Wrap(alignment: WrapAlignment.center, spacing: 26, runSpacing: 8, children: [
              legendItem(acc2, 'ว่าง'),
              legendItem(offC, 'ไม่ว่าง'),
              legendItem(acc, 'ที่เลือก'),
            ]),
          ),

          // ── แลกแต้ม ──
          if (avail >= 15)
            card(SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('ใช้ 15 แต้ม แลกฟรี 1 ชั่วโมง (-35 บาท)', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('แต้มคงเหลือ $avail'),
              value: redeem,
              onChanged: (v) {
                redeem = v;
                fix();
              },
            )),

          // ── ราคา ──
          lbl('รายละเอียดราคา'),
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('• รายชั่วโมง 35 บาท / คน / ชั่วโมง', style: TextStyle(color: txt2)),
            const SizedBox(height: 2),
            const Text('• เหมาวัน 135 บาท / คน', style: TextStyle(color: txt2)),
            const Divider(height: 22),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Expanded(child: Text('ราคาที่ต้องชำระ', style: TextStyle(fontWeight: FontWeight.w700))),
              Text('${base - disc} บาท', style: const TextStyle(color: goldDk, fontSize: 22, fontWeight: FontWeight.w900)),
            ]),
          ])),

          // ── ปุ่มยืนยัน ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 19, 8),
            child: SizedBox(
              height: 56,
              child: nb(
                Center(child: Text(table == null ? 'เลือกโต๊ะก่อนยืนยัน' : 'ยืนยันการจอง', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: dk))),
                fill: gold,
                r: 16,
                onTap: () {
                  if (table == null) {
                    snack(context, 'กรุณาเลือกโต๊ะก่อนยืนยันการจอง');
                    return;
                  }
                  final b = B(u: S.i.me!, g: widget.g, ppl: ppl, full: full, date: date, start: s, hours: h, table: table!, price: base - disc, used: redeem ? 1 : 0);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Summary(b, widget.edit)));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
