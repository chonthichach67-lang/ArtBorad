import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/game_card.dart';
import 'package:testtt/screens/customer/book_page.dart';

class BookTab extends StatelessWidget {
  const BookTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(children: [
        const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('เลือกบอร์ดเกมที่อยากเล่น', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        for (final g in AppState.i.games) GameCard(g, trailing: const Icon(Icons.chevron_right, color: acc), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(g)))),
      ]);
}
