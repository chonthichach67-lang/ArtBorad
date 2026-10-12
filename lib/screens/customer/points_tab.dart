import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/neon.dart';

class PointsTab extends StatelessWidget {
  const PointsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final p = AppState.i.me!.pts;
    return ListView(children: [
      card(Column(children: [
        const Text('แต้มสะสมของคุณ', style: TextStyle(color: Colors.white60)),
        Text('$p', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: acc, shadows: glowS)),
        LinearProgressIndicator(value: (p % 15) / 15, minHeight: 8, borderRadius: BorderRadius.circular(8)),
        const SizedBox(height: 8),
        Text(p >= 15 ? 'แลกเล่นฟรี 1 ชั่วโมงได้แล้ว! (ตอนจอง)' : 'อีก ${15 - p} แต้ม แลกฟรี 1 ชั่วโมง'),
      ])),
      card(const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('วิธีสะสมแต้ม', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('• ทุก 35 บาท ได้ 1 แต้ม (คำนวณอัตโนมัติหลังจอง)'),
        Text('• ลงสตอรี่แท็กร้าน ได้เพิ่ม 1 แต้ม (แจ้งแอดมิน)'),
        Text('• สะสมครบ 15 แต้ม แลกฟรี 1 ชั่วโมง'),
      ])),
    ]);
  }
}
