import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/game_card.dart';
import '../../widgets/section_title.dart';

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        Sec('บอร์ดเกมทั้งหมด', trailing: Text('${S.i.games.length} เกม', style: const TextStyle(color: txt2, fontSize: 13))),
        for (final g in S.i.games) GameCard(g),
      ]);
}
