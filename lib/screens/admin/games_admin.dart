import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/models/board_game.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/form_fields.dart';
import 'package:testtt/widgets/game_card.dart';

class GamesAdmin extends StatelessWidget {
  const GamesAdmin({super.key});

  void _showAddGameDialog(BuildContext context) {
    final nameC = TextEditingController();
    final descC = TextEditingController();
    final minC = TextEditingController(text: '2');
    final maxC = TextEditingController(text: '4');
    final minsC = TextEditingController(text: '30');
    String diff = 'ปานกลาง';

    showDialog(
      context: context,
      builder: (d) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('เพิ่มบอร์ดเกมใหม่'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                tf(nameC, 'ชื่อเกม'),
                tf(descC, 'คำอธิบาย'),
                Row(
                  children: [
                    Expanded(child: tf(minC, 'คนน้อยสุด', k: TextInputType.number)),
                    const SizedBox(width: 8),
                    Expanded(child: tf(maxC, 'คนมากสุด', k: TextInputType.number)),
                  ],
                ),
                tf(minsC, 'เวลาที่ใช้ (นาที)', k: TextInputType.number),
                DropdownButtonFormField<String>(
                  value: diff,
                  decoration: const InputDecoration(labelText: 'ความยาก', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'ง่าย', child: Text('ง่าย')),
                    DropdownMenuItem(value: 'ปานกลาง', child: Text('ปานกลาง')),
                    DropdownMenuItem(value: 'ยาก', child: Text('ยาก')),
                  ],
                  onChanged: (v) {
                    if (v != null) setStateDialog(() => diff = v);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(d), child: const Text('ยกเลิก')),
            FilledButton(
              onPressed: () {
                final name = nameC.text.trim();
                if (name.isEmpty) return snack(context, 'กรุณากรอกชื่อเกม');
                final min = int.tryParse(minC.text) ?? 2;
                final max = int.tryParse(maxC.text) ?? 4;
                final mins = int.tryParse(minsC.text) ?? 30;

                AppState.i.games.add(BoardGame(name, descC.text.trim(), min, max, diff, mins));
                AppState.i.ping();
                Navigator.pop(d);
                snack(context, 'เพิ่มเกม $name สำเร็จ');
              },
              child: const Text('เพิ่มเกม'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [for (final g in AppState.i.games) GameCard(g)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGameDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('เพิ่มเกม'),
        backgroundColor: acc,
        foregroundColor: Colors.black,
      ),
    );
  }
}
