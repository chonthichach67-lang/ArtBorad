import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/logo.dart';
import '../auth/auth_actions.dart';
import 'add_game_dialog.dart';
import 'admin_bookings_tab.dart';
import 'admin_chats_tab.dart';
import 'admin_games_tab.dart';
import 'admin_points_tab.dart';
import 'admin_tables_tab.dart';
import 'notifications_sheet.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int tab = 0;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: S.i,
        builder: (_, __) {
          final customers = S.i.users.where((u) => !u.admin).toList();
          final pages = [
            AdminTablesTab(),
            AdminBookingsTab(),
            AdminGamesTab(),
            AdminPointsTab(customers),
            AdminChatsTab(customers),
          ];
          return Scaffold(
            appBar: AppBar(
              title: const Row(children: [
                Logo(34),
                SizedBox(width: 10),
                Flexible(child: Text('ARTBOARD  ADMIN', overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5))),
              ]),
              actions: [
                IconButton(tooltip: 'แจ้งเตือน', icon: const Icon(Icons.notifications_none_rounded), onPressed: () => showNotificationsSheet(context)),
                IconButton(tooltip: 'ออกจากระบบ', icon: const Icon(Icons.logout_rounded), onPressed: () => logout(context)),
                const SizedBox(width: 4),
              ],
            ),
            body: IndexedStack(index: tab, children: pages),
            floatingActionButton: tab == 2
                ? FloatingActionButton.extended(
                    onPressed: () => showAddGameDialog(context),
                    backgroundColor: gold,
                    foregroundColor: dk,
                    icon: const Icon(Icons.add),
                    label: const Text('เพิ่มเกม', style: TextStyle(fontWeight: FontWeight.w900)),
                  )
                : null,
            bottomNavigationBar: SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  border: Border(top: BorderSide(color: al(ink, .45), width: 1.5)),
                ),
                child: NavigationBar(
                  height: 72,
                  backgroundColor: bg,
                  indicatorColor: al(acc2, .28),
                  selectedIndex: tab,
                  onDestinationSelected: (v) => setState(() => tab = v),
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), selectedIcon: Icon(Icons.table_restaurant), label: 'โต๊ะ'),
                    NavigationDestination(icon: Icon(Icons.view_list_outlined), selectedIcon: Icon(Icons.view_list), label: 'คิวจอง'),
                    NavigationDestination(icon: Icon(Icons.casino_outlined), selectedIcon: Icon(Icons.casino), label: 'เกม'),
                    NavigationDestination(icon: Icon(Icons.stars_outlined), selectedIcon: Icon(Icons.stars), label: 'แต้ม'),
                    NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'แชท'),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
