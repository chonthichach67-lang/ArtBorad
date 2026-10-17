import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/pip_bar.dart';
import '../../widgets/section_title.dart';
import '../../widgets/ui_helpers.dart';

class PointsTab extends StatelessWidget {
  const PointsTab({super.key});

  Widget step(IconData i, String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(i, size: 18, color: goldDk),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: const TextStyle(height: 1.3))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final p = S.i.me!.pts;
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      card(Column(children: [
        const Text('แต้มสะสมของคุณ', style: TextStyle(color: txt2)),
        Text('$p', style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900, color: gold, height: 1.1, shadows: [Shadow(color: shd, offset: Offset(3, 3))])),
        const SizedBox(height: 6),
        Center(child: PipBar(p >= 15 ? 15 : p)),
        const SizedBox(height: 12),
        Text(p >= 15 ? 'แลกเล่นฟรี 1 ชั่วโมงได้แล้ว! (ตอนจอง)' : 'อีก ${15 - p} แต้ม แลกฟรี 1 ชั่วโมง', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
      ])),
      const Sec('วิธีสะสมแต้ม'),
      card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        step(Icons.payments_outlined, 'ทุก 35 บาท ได้ 1 แต้ม (คำนวณอัตโนมัติหลังจอง)'),
        step(Icons.photo_camera_outlined, 'ลงสตอรี่แท็กร้าน ได้เพิ่ม 1 แต้ม (แจ้งแอดมิน)'),
        step(Icons.redeem_outlined, 'สะสมครบ 15 แต้ม แลกฟรี 1 ชั่วโมง'),
      ])),
    ]);
  }
}
