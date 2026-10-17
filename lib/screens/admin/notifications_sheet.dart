import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/ui_helpers.dart';

/// แผ่นแจ้งเตือนของแอดมิน
void showNotificationsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: bg2,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      side: BorderSide(color: ink, width: 2),
    ),
    builder: (ctx) => SafeArea(
      child: SizedBox(
        height: MediaQuery.of(ctx).size.height * .65,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('แจ้งเตือน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          ),
          Expanded(
            child: S.i.notes.isEmpty
                ? emptyState(Icons.notifications_none, 'ยังไม่มีการแจ้งเตือน')
                : ListView(children: [
                    for (final n in S.i.notes.reversed)
                      card(Text(n, style: const TextStyle(height: 1.35))),
                  ]),
          ),
        ]),
      ),
    ),
  );
}
