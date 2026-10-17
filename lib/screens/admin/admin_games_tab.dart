import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/game_card.dart';
import '../../widgets/section_title.dart';

/// แท็บบอร์ดเกมในร้าน (แอดมิน)
/// หมายเหตุ: ตั้งใจ "ไม่" ทำ constructor เป็น const เพื่อให้ถูกสร้างใหม่ทุกครั้งที่ S แจ้งเปลี่ยน
/// (ถ้าเป็น const Flutter จะข้ามการ rebuild แล้วหน้าจอไม่อัปเดต)
class AdminGamesTab extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AdminGamesTab({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 90), children: [
        Sec('บอร์ดเกมในร้าน', trailing: Text('${S.i.games.length} เกม', style: const TextStyle(color: txt2, fontSize: 13))),
        for (final g in S.i.games) GameCard(g),
      ]);
}
