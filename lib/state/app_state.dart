import 'package:flutter/material.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/models/app_user.dart';
import 'package:testtt/models/board_game.dart';
import 'package:testtt/models/booking.dart';
import 'package:testtt/models/chat_message.dart';

class AppState extends ChangeNotifier {
  static final i = AppState._();
  AppState._();
  final users = <AppUser>[
    AppUser('admin', 'admin', admin: true),
    AppUser('user1', '1234', phone: '0812345678', email: 'user1@gmail.com'),
    AppUser('somchai', '123456', phone: '0898765432', email: 'somchai@email.com'),
    AppUser('mairoo', 'mairoo123M', phone: '0610000001', email: 'mairo0123@gmail.com'),
  ];
  AppUser? me;
  final bookings = <Booking>[];
  final chats = <AppUser, List<ChatMessage>>{};
  final notes = <String>[];
  final closed = <int>{};
  int _id = 1;
  final games = <BoardGame>[
    BoardGame("อย่าซ่ากับบอส - I'm the boss!", 'เจรจาต่อรองปิดดีลธุรกิจ แย่งกันรวยที่สุด', 3, 6, 'ปานกลาง', 60),
    BoardGame('โค้ดเนมส์ - Codenames', 'เกมทีมใบ้คำ ให้เพื่อนทายตามคำใบ้คำเดียว', 4, 8, 'ง่าย', 20),
    BoardGame('เกมล่าแม่มด - Salem 1692', 'หาตัวแม่มดท่ามกลางชาวบ้านด้วยการกล่าวหา', 4, 12, 'ปานกลาง', 45),
    BoardGame('วิ่งสู้ฟาสต์ - Magical Athlete', 'แข่งวิ่งด้วยพลังพิเศษสุดป่วนของนักกีฬา', 2, 6, 'ง่าย', 30),
    BoardGame('ผู้ตรวจการณ์แห่งน็อตติงแฮม - Sheriff of Nottingham', 'เกมโกหกและต่อรองลักลอบนำสินค้าเข้าเมือง', 3, 5, 'ปานกลาง', 60),
    BoardGame('สีสันบรรเทิง - Hues and Cues', 'ใบ้สีด้วยคำไม่เกินสองคำ แล้วให้เพื่อนวางหมุด', 3, 10, 'ง่าย', 40),
    BoardGame('Splendor - เกมค้าเพชร', 'สะสมเพชรและการ์ดเพื่อสร้างอาณาจักรการค้า', 2, 4, 'ปานกลาง', 30),
    BoardGame('Dead by daylight - เดธบายเดย์ไลท์', 'เกมหนีฆาตกรจากเกมดังบนโต๊ะ', 3, 5, 'ปานกลาง', 45),
    BoardGame('ชีสหนูอยู่ไหน - Cheese Thieves', 'หนูขโมยชีสช่วยกันหาว่าใครคือสายลับ', 3, 8, 'ง่าย', 20),
    BoardGame('แฟ้มคดีปริศนา - CS Files', 'ไขคดีปริศนาจากเบาะแสในแฟ้มคดี', 1, 6, 'ยาก', 90),
    BoardGame('อวาลอน - Avalon', 'ฝ่ายคุณธรรมปะทะฝ่ายชั่วร้าย ซ่อนตัวตนและโหวตภารกิจ', 5, 10, 'ปานกลาง', 30),
    BoardGame('บิดแล้วรวย', 'ประมูลแข่งกันเพื่อกอบโกยทรัพย์สิน', 3, 6, 'ง่าย', 30),
    BoardGame('ดีลเดือดเชือดตลาดหุ้น - Wolf Street', 'เทรดหุ้นปั่นราคาแข่งกันเป็นเจ้าตลาด', 3, 6, 'ยาก', 60),
  ];

  void ping() => notifyListeners();

  bool free(int t, DateTime d, int s, int h, [Booking? ex]) {
    if (closed.contains(t)) return false;
    return !bookings.any((b) => b != ex && b.status != 'ยกเลิก' && b.table == t && sameDay(b.date, d) && s < b.start + b.hours && b.start < s + h);
  }

  void _revert(Booking b) => b.u.pts += b.used * 15 - b.earn;

  void save(Booking nb, Booking? old) {
    if (old != null) {
      _revert(old);
      nb.id = old.id;
      bookings[bookings.indexOf(old)] = nb;
    } else {
      nb.id = _id++;
      bookings.add(nb);
    }
    nb.u.pts += nb.earn - nb.used * 15;
    notes.add('🪑 ${old == null ? "จองใหม่" : "แก้ไขการจอง"} #${nb.id} ${nb.u.name} โต๊ะ ${nb.table} ${fmtD(nb.date)} ${fmtT(nb.start, nb.hours)}');
    ping();
  }

  void cancel(Booking b) {
    _revert(b);
    b.status = 'ยกเลิก';
    notes.add('❌ ยกเลิกการจอง #${b.id} โดย ${b.u.name}');
    ping();
  }
}
