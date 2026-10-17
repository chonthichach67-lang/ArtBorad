import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/game_card.dart';
import '../../widgets/section_title.dart';
import 'book_page.dart';

class BookTab extends StatelessWidget {
  const BookTab({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('เลือกบอร์ดเกมที่อยากเล่น'),
        for (final g in S.i.games) GameCard(g, trailing: const Icon(Icons.chevron_right, color: acc), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(g)))),
      ]);
}
