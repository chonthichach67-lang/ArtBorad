import 'package:flutter/material.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/game_card.dart';

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(children: [for (final g in AppState.i.games) GameCard(g)]);
}
