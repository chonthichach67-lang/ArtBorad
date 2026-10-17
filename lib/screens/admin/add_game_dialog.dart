import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../models/game.dart';
import '../../state/app_state.dart';
import '../../widgets/form_fields.dart';

/// ป๊อปอัปเพิ่มบอร์ดเกมใหม่
void showAddGameDialog(BuildContext context) {
  final name = TextEditingController();
  final desc = TextEditingController();
  final min = TextEditingController(text: '2');
  final max = TextEditingController(text: '6');
  final mins = TextEditingController(text: '30');
  String diff = 'ง่าย';
  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(builder: (ctx, refresh) => AlertDialog(
      backgroundColor: cardC,
      shape: dlgShape,
      title: const Text('เพิ่มบอร์ดเกม'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        tf(name, 'ชื่อเกม'),
        tf(desc, 'รายละเอียดเกม'),
        Row(children: [
          Expanded(child: tf(min, 'คนต่ำสุด', k: TextInputType.number)),
          const SizedBox(width: 8),
          Expanded(child: tf(max, 'คนสูงสุด', k: TextInputType.number)),
        ]),
        tf(mins, 'เวลา (นาที)', k: TextInputType.number),
        DropdownButtonFormField<String>(
          value: diff,
          decoration: const InputDecoration(labelText: 'ระดับความยาก'),
          items: const [
            DropdownMenuItem(value: 'ง่าย', child: Text('ง่าย')),
            DropdownMenuItem(value: 'ปานกลาง', child: Text('ปานกลาง')),
            DropdownMenuItem(value: 'ยาก', child: Text('ยาก')),
          ],
          onChanged: (v) => refresh(() => diff = v ?? 'ง่าย'),
        ),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
        FilledButton(
          onPressed: () {
            final lo = int.tryParse(min.text) ?? 0;
            final hi = int.tryParse(max.text) ?? 0;
            final duration = int.tryParse(mins.text) ?? 0;
            if (name.text.trim().isEmpty || lo < 1 || hi < lo || duration < 1) {
              snack(context, 'กรุณากรอกข้อมูลเกมให้ถูกต้อง');
              return;
            }
            S.i.games.add(Game(name.text.trim(), desc.text.trim(), lo, hi, diff, duration));
            S.i.notes.add('🎲 เพิ่มเกม ${name.text.trim()}');
            S.i.ping();
            Navigator.pop(ctx);
          },
          child: const Text('บันทึกเกม'),
        ),
      ],
    )),
  ).then((_) {
    name.dispose(); desc.dispose(); min.dispose(); max.dispose(); mins.dispose();
  });
}
