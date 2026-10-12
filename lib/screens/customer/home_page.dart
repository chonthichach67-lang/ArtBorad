import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/logo.dart';
import 'package:testtt/widgets/neon.dart';
import 'package:testtt/widgets/sub_page.dart';
import 'package:testtt/screens/chat/chat_page.dart';
import 'package:testtt/screens/customer/book_tab.dart';
import 'package:testtt/screens/customer/games_tab.dart';
import 'package:testtt/screens/customer/history_tab.dart';
import 'package:testtt/screens/customer/points_tab.dart';
import 'package:testtt/screens/customer/profile_tab.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  void go(BuildContext c, String t, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => SubPage(t, w)));

  Widget menu(BuildContext c, IconData i, String t, String sub, Widget w) => InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => go(c, t, w),
      child: Container(
          decoration: neon(a: .35),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(i, size: 38, color: acc),
            const SizedBox(height: 10),
            Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ])));

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: AppState.i,
      builder: (_, __) {
        final u = AppState.i.me!;
        return Scaffold(
            appBar: AppBar(
                title: const Row(children: [Logo(36), SizedBox(width: 10), Text('ARTBOARD', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3))]),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => go(context, 'โปรไฟล์', const ProfileTab()),
                          child: CircleAvatar(radius: 19, backgroundColor: u.photo ? acc : Colors.white12, child: Icon(Icons.person, color: u.photo ? Colors.black : Colors.white54))))
                ]),
            body: Column(children: [
              Expanded(
                  child: ListView(padding: const EdgeInsets.only(top: 8, bottom: 16), children: [
                Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 0), child: Text('สวัสดี, ${u.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                InkWell(
                    onTap: () => go(context, 'สะสมแต้ม', const PointsTab()),
                    child: card(Row(children: [
                      const Icon(Icons.stars, color: acc, size: 36),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('แต้มสะสมของคุณ', style: TextStyle(color: Colors.white60)),
                        Text('${u.pts} แต้ม', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: acc, shadows: glowS)),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(value: (u.pts % 15) / 15, minHeight: 6, borderRadius: BorderRadius.circular(6)),
                        const SizedBox(height: 4),
                        Text(u.pts >= 15 ? 'แลกฟรี 1 ชั่วโมงได้แล้ว!' : 'อีก ${15 - u.pts} แต้ม แลกฟรี 1 ชั่วโมง', style: const TextStyle(fontSize: 12, color: Colors.white54)),
                      ])),
                    ]))),
                GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.15,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    children: [
                      menu(context, Icons.casino_outlined, 'บอร์ดเกม', 'รายชื่อและรายละเอียดเกม', const GamesTab()),
                      menu(context, Icons.event_seat_outlined, 'จองโต๊ะ', 'เลือกเกม วัน เวลา โต๊ะ', const BookTab()),
                      menu(context, Icons.stars_outlined, 'สะสมแต้ม', 'ดูแต้มและวิธีแลก', const PointsTab()),
                      menu(context, Icons.history, 'ประวัติ', 'ดู แก้ไข ยกเลิกการจอง', const HistoryTab()),
                    ]),
              ])),
              SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(u, false))),
                              icon: const Icon(Icons.support_agent),
                              label: const Text('ติดต่อแอดมิน'))))),
            ]));
      });
}
