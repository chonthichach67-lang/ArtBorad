import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../widgets/logo.dart';
import '../../widgets/neon.dart';
import '../../widgets/pip_bar.dart';
import '../../widgets/sub_page.dart';
import '../../widgets/ui_helpers.dart';
import '../chat/chat_page.dart';
import 'book_tab.dart';
import 'games_tab.dart';
import 'history_tab.dart';
import 'points_tab.dart';
import 'profile_tab.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void go(BuildContext c, String t, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => SubPage(t, w)));

  Widget menu(BuildContext c, IconData i, String t, String sub, Color col, Widget w) => Container(
        decoration: neon(),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => go(c, t, w),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: col, borderRadius: BorderRadius.circular(14), border: Border.all(color: ink, width: 2)),
                  child: Icon(i, size: 24, color: col == acc ? Colors.white : dk),
                ),
                const SizedBox(height: 10),
                Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 2),
                Text(sub, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: txt2, fontSize: 12, height: 1.25)),
              ]),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: S.i,
        builder: (_, __) {
          final u = S.i.me!;
          return Scaffold(
            appBar: AppBar(
              title: const Row(children: [
                Logo(34),
                SizedBox(width: 10),
                Flexible(child: Text('ARTBOARD', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3))),
              ]),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => go(context, 'โปรไฟล์', const ProfileTab()),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ink, width: 2)),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: u.photo ? acc : sand,
                        child: Icon(Icons.person, color: u.photo ? Colors.white : txt2),
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: Column(children: [
              Expanded(
                child: ListView(padding: const EdgeInsets.only(top: 4, bottom: 16), children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 8),
                    child: Text('สวัสดี, ${u.name}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  ),
                  card(
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Row(children: [
                        Icon(Icons.toll_rounded, color: goldDk, size: 20),
                        SizedBox(width: 8),
                        Expanded(child: Text('แต้มสะสมของคุณ', style: TextStyle(color: txt2))),
                        Icon(Icons.chevron_right, color: txt3),
                      ]),
                      const SizedBox(height: 4),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${u.pts}', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: gold, height: 1.1, shadows: [Shadow(color: shd, offset: Offset(2, 2))])),
                        const SizedBox(width: 8),
                        const Padding(padding: EdgeInsets.only(bottom: 8), child: Text('แต้ม', style: TextStyle(color: txt2, fontSize: 15))),
                      ]),
                      const SizedBox(height: 8),
                      PipBar(u.pts >= 15 ? 15 : u.pts),
                      const SizedBox(height: 8),
                      Text(
                        u.pts >= 15 ? 'แลกฟรี 1 ชั่วโมงได้แล้ว!' : 'อีก ${15 - u.pts} แต้ม แลกฟรี 1 ชั่วโมง',
                        style: TextStyle(fontSize: 12.5, color: u.pts >= 15 ? goldDk : txt2, fontWeight: u.pts >= 15 ? FontWeight.w800 : FontWeight.w400),
                      ),
                    ]),
                    onTap: () => go(context, 'สะสมแต้ม', const PointsTab()),
                  ),
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 10, 19, 0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 14, crossAxisSpacing: 14, mainAxisExtent: 156),
                    children: [
                      menu(context, Icons.casino_outlined, 'บอร์ดเกม', 'รายชื่อและรายละเอียดเกม', acc, const GamesTab()),
                      menu(context, Icons.event_seat_outlined, 'จองโต๊ะ', 'เลือกเกม วัน เวลา โต๊ะ', acc2, const BookTab()),
                      menu(context, Icons.toll_outlined, 'สะสมแต้ม', 'ดูแต้มและวิธีแลก', gold, const PointsTab()),
                      menu(context, Icons.history, 'ประวัติ', 'ดู แก้ไข ยกเลิกการจอง', violet, const HistoryTab()),
                    ],
                  ),
                ]),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 19, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: hard(FilledButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(u, false))),
                      icon: const Icon(Icons.support_agent),
                      label: const Text('ติดต่อแอดมิน'),
                    )),
                  ),
                ),
              ),
            ]),
          );
        },
      );
}
