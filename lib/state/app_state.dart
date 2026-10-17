import 'dart:math';
import 'package:flutter/material.dart';
import '../core/db.dart';
import '../core/utils.dart';
import '../models/booking.dart';
import '../models/game.dart';
import '../models/message.dart';
import '../models/user.dart';

class S extends ChangeNotifier {
  static final i = S._();
  S._();

  // ข้อมูลตั้งต้น (seed): ใช้แค่ตอนเปิดแอปครั้งแรก หลังจากนั้นข้อมูลมาจากฐานข้อมูล
  final users = <U>[
    U('admin', 'admin', admin: true),
    U('user1', '1234', phone: '0812345678', email: 'user1@gmail.com'),
    U('somchai', '123456', phone: '0898765432', email: 'somchai@email.com'),
    U('mairoo', 'mairoo123M', phone: '0610000001', email: 'mairo0123@gmail.com'),
  ];
  U? me;
  final bookings = <B>[];
  final chats = <U, List<M>>{};
  final notes = <String>[];
  final closed = <int>{};
  int _id = 1;

  final games = <Game>[
    Game("อย่าซ่ากับบอส - I'm the boss!", 'เจรจาต่อรองปิดดีลธุรกิจ แย่งกันรวยที่สุด', 3, 6, 'ปานกลาง', 60,'assets/images/I_m the boss!.jpg'),
    Game('โค้ดเนมส์ - Codenames', 'เกมทีมใบ้คำ ให้เพื่อนทายตามคำใบ้คำเดียว', 4, 8, 'ง่าย', 20,'assets/images/Codenames.jpg'),
    Game('เกมล่าแม่มด - Salem 1692', 'หาตัวแม่มดท่ามกลางชาวบ้านด้วยการกล่าวหา', 4, 12, 'ปานกลาง', 45,'assets/images/Salem1692.jpg'),
    Game('วิ่งสู้ฟาสต์ - Magical Athlete', 'แข่งวิ่งด้วยพลังพิเศษสุดป่วนของนักกีฬา', 2, 6, 'ง่าย', 30,'assets/images/Magical Athlete.jpg'),
    Game('ผู้ตรวจการณ์แห่งน็อตติงแฮม - Sheriff of Nottingham', 'เกมโกหกและต่อรองลักลอบนำสินค้าเข้าเมือง', 3, 5, 'ปานกลาง', 60,'assets/images/Sheriff of Nottingham.jpg'),
    Game('สีสันบรรเทิง - Hues and Cues', 'ใบ้สีด้วยคำไม่เกินสองคำ แล้วให้เพื่อนวางหมุด', 3, 10, 'ง่าย', 40,'assets/images/Hues and Cues.jpg'), // แก้จาก assets/image/
    Game('Splendor - เกมค้าเพชร', 'สะสมเพชรและการ์ดเพื่อสร้างอาณาจักรการค้า', 2, 4, 'ปานกลาง', 30,'assets/images/Splendor.jpg'),
    Game('Dead by daylight - เดธบายเดย์ไลท์', 'เกมหนีฆาตกรจากเกมดังบนโต๊ะ', 3, 5, 'ปานกลาง', 45,'assets/images/Dead by daylight.jpg'),
    Game('ชีสหนูอยู่ไหน - Cheese Thieves', 'หนูขโมยชีสช่วยกันหาว่าใครคือสายลับ', 3, 8, 'ง่าย', 20,'assets/images/Cheese Thieves.jpg'),
    Game('แฟ้มคดีปริศนา - CS Files', 'ไขคดีปริศนาจากเบาะแสในแฟ้มคดี', 1, 6, 'ยาก', 90,'assets/images/CS Files.jpg'),
    Game('อวาลอน - Avalon', 'ฝ่ายคุณธรรมปะทะฝ่ายชั่วร้าย ซ่อนตัวตนและโหวตภารกิจ', 5, 10, 'ปานกลาง', 30,'assets/images/Avalon.jpg'),
    Game('บิดแล้วรวย', 'ประมูลแข่งกันเพื่อกอบโกยทรัพย์สิน', 3, 6, 'ง่าย', 30,'assets/images/For sale.webp'),
    Game('ดีลเดือดเชือดตลาดหุ้น - Wolf Street', 'เทรดหุ้นปั่นราคาแข่งกันเป็นเจ้าตลาด', 3, 6, 'ยาก', 60,'assets/images/Wolf Street.webp'),
  ];

  // ---------- ฐานข้อมูล ----------
  /// เรียกครั้งเดียวใน main() ก่อน runApp
  Future<void> init() async {
    final d = AppDb.i;
    await d.open();
    if (await d.isEmpty('users')) {
      // เปิดแอปครั้งแรก: เขียนข้อมูลตั้งต้นด้านบนลงฐานข้อมูล
      await d.saveAll(users: users, games: games, bookings: bookings, chats: chats, notes: notes, closed: closed);
    }
    final us = await d.loadUsers();
    final gs = await d.loadGames();
    final bs = await d.loadBookings(us, gs);
    final cs = await d.loadChats(us);
    final ns = await d.loadNotes();
    final cl = await d.loadClosed();
    users..clear()..addAll(us);
    games..clear()..addAll(gs);
    bookings..clear()..addAll(bs);
    chats..clear()..addAll(cs);
    notes..clear()..addAll(ns);
    closed..clear()..addAll(cl);
    _id = bookings.fold(0, (m, b) => b.id > m ? b.id : m) + 1;
  }

  bool _saving = false, _dirty = false;

  Future<void> _persist() async {
    if (_saving) {
      _dirty = true; // กำลังเขียนอยู่ ให้เขียนซ้ำอีกรอบหลังจบ
      return;
    }
    _saving = true;
    try {
      do {
        _dirty = false;
        await AppDb.i.saveAll(users: users, games: games, bookings: bookings, chats: chats, notes: notes, closed: closed);
      } while (_dirty);
    } finally {
      _saving = false;
    }
  }

  /// หน้าจอเรียก ping() หลังแก้ข้อมูลอยู่แล้ว จึงบันทึกลงฐานข้อมูลที่นี่ด้วย
  void ping() {
    notifyListeners();
    _persist();
  }

  bool free(int t, DateTime d, int s, int h, [B? ex]) {
    if (closed.contains(t)) return false;
    return !bookings.any((b) => b != ex && b.status != 'ยกเลิก' && b.table == t && sameDay(b.date, d) && s < b.start + b.hours && b.start < s + h);
  }

  void _revert(B b) => b.u.pts = max(0, b.u.pts + b.used * 15 - b.earn);

  void save(B nb, B? old) {
    if (old != null) {
      if (old.status == 'ยกเลิก') return; // แก้การจองที่ยกเลิกไปแล้วไม่ได้
      _revert(old);
      nb.id = old.id;
      bookings[bookings.indexOf(old)] = nb;
    } else {
      nb.id = _id++;
      bookings.add(nb);
    }
    nb.u.pts = max(0, nb.u.pts + nb.earn - nb.used * 15);
    notes.add('🪑 ${old == null ? "จองใหม่" : "แก้ไขการจอง"} #${nb.id} ${nb.u.name} โต๊ะ ${nb.table} ${fmtD(nb.date)} ${fmtT(nb.start, nb.hours)}');
    ping();
  }

  void cancel(B b) {
    if (b.status == 'ยกเลิก') return; // กันยกเลิกซ้ำแล้วแต้มเพี้ยน
    _revert(b);
    b.status = 'ยกเลิก';
    notes.add('❌ ยกเลิกการจอง #${b.id} โดย ${b.u.name}');
    ping();
  }

  /// แอดมินปรับแต้มลูกค้า เช่น +1 จากการลงสตอรี่แท็กร้าน
  void adjustPts(U u, int d) {
    if (u.pts + d < 0) return;
    u.pts += d;
    notes.add('⭐ ${d > 0 ? "เพิ่ม" : "ลด"}แต้ม ${u.name} ${d > 0 ? "+" : ""}$d (รวม ${u.pts} แต้ม)');
    ping();
  }
}