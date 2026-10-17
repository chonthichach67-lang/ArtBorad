import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/booking.dart';
import '../models/game.dart';
import '../models/message.dart';
import '../models/user.dart';

/// ชั้นเก็บข้อมูลลง SQLite ให้ S (app_state.dart)
/// S ยังเป็นตัวหลักในหน่วยความจำ: ตอนเปิดแอป load() เข้า S, ทุกครั้งที่ S.ping() ก็ saveAll() ลงฐานข้อมูล
class AppDb {
  AppDb._();
  static final i = AppDb._();
  late Database _d;

  Future<void> open() async {
    _d = await openDatabase(
      join(await getDatabasesPath(), 'artboard.db'),
      version: 1,
      onCreate: (d, _) async {
        await d.execute('''CREATE TABLE users(
          id INTEGER PRIMARY KEY, name TEXT NOT NULL, password TEXT NOT NULL,
          phone TEXT, email TEXT, pts INTEGER NOT NULL DEFAULT 0,
          photo INTEGER NOT NULL DEFAULT 0, is_admin INTEGER NOT NULL DEFAULT 0)''');
        await d.execute('''CREATE TABLE games(
          id INTEGER PRIMARY KEY, name TEXT NOT NULL, descr TEXT, diff TEXT,
          img TEXT, min_p INTEGER, max_p INTEGER, mins INTEGER)''');
        await d.execute('''CREATE TABLE bookings(
          id INTEGER PRIMARY KEY, user_id INTEGER NOT NULL, game_id INTEGER NOT NULL,
          ppl INTEGER, is_full INTEGER, date TEXT, start_h INTEGER, hours INTEGER,
          tbl INTEGER, price INTEGER, used INTEGER, status TEXT)''');
        await d.execute('''CREATE TABLE messages(
          id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL,
          is_admin INTEGER NOT NULL, t TEXT NOT NULL)''');
        await d.execute('''CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT, t TEXT NOT NULL)''');
        await d.execute('CREATE TABLE closed_tables(tbl INTEGER PRIMARY KEY)');
      },
    );
  }

  Future<bool> isEmpty(String table) async =>
      (Sqflite.firstIntValue(await _d.rawQuery('SELECT COUNT(*) FROM $table')) ?? 0) == 0;

  // ---------------- เขียน ----------------
  /// เขียนข้อมูลทั้งหมดลงฐานข้อมูลในทรานแซกชันเดียว (ข้อมูลร้านเล็ก เขียนทับทั้งชุดได้)
  /// id ที่ยังเป็น 0 ของ U / Game จะถูกกำหนดให้ที่นี่
  Future<void> saveAll({
    required List<U> users,
    required List<Game> games,
    required List<B> bookings,
    required Map<U, List<M>> chats,
    required List<String> notes,
    required Set<int> closed,
  }) async {
    int next(Iterable<int> ids) => ids.fold(0, (m, x) => x > m ? x : m) + 1;
    var uid = next(users.map((u) => u.id));
    for (final u in users) {
      if (u.id == 0) u.id = uid++;
    }
    var gid = next(games.map((g) => g.id));
    for (final g in games) {
      if (g.id == 0) g.id = gid++;
    }
    final uids = users.map((u) => u.id).toSet();
    final gids = games.map((g) => g.id).toSet();

    await _d.transaction((t) async {
      final b = t.batch();
      for (final tb in ['users', 'games', 'bookings', 'messages', 'notes', 'closed_tables']) {
        b.delete(tb);
      }
      for (final u in users) {
        b.insert('users', {
          'id': u.id, 'name': u.name, 'password': u.pass, 'phone': u.phone,
          'email': u.email, 'pts': u.pts, 'photo': u.photo ? 1 : 0,
          'is_admin': u.admin ? 1 : 0,
        });
      }
      for (final g in games) {
        b.insert('games', {
          'id': g.id, 'name': g.name, 'descr': g.desc, 'diff': g.diff,
          'img': g.img, 'min_p': g.min, 'max_p': g.max, 'mins': g.mins,
        });
      }
      for (final k in bookings) {
        if (!uids.contains(k.u.id) || !gids.contains(k.g.id)) continue;
        b.insert('bookings', {
          'id': k.id, 'user_id': k.u.id, 'game_id': k.g.id, 'ppl': k.ppl,
          'is_full': k.full ? 1 : 0, 'date': k.date.toIso8601String(),
          'start_h': k.start, 'hours': k.hours, 'tbl': k.table,
          'price': k.price, 'used': k.used, 'status': k.status,
        });
      }
      for (final e in chats.entries) {
        if (!uids.contains(e.key.id)) continue;
        for (final m in e.value) {
          b.insert('messages', {'user_id': e.key.id, 'is_admin': m.admin ? 1 : 0, 't': m.t});
        }
      }
      for (final n in notes) {
        b.insert('notes', {'t': n});
      }
      for (final c in closed) {
        b.insert('closed_tables', {'tbl': c});
      }
      await b.commit(noResult: true);
    });
  }

  // ---------------- อ่าน ----------------
  Future<List<U>> loadUsers() async => (await _d.query('users', orderBy: 'id'))
      .map((r) => U(r['name'] as String, r['password'] as String,
          phone: (r['phone'] as String?) ?? '',
          email: (r['email'] as String?) ?? '',
          admin: r['is_admin'] == 1)
        ..id = r['id'] as int
        ..pts = r['pts'] as int
        ..photo = r['photo'] == 1)
      .toList();

  Future<List<Game>> loadGames() async => (await _d.query('games', orderBy: 'id'))
      .map((r) => Game(
            r['name'] as String,
            (r['descr'] as String?) ?? '',
            r['min_p'] as int,
            r['max_p'] as int,
            (r['diff'] as String?) ?? '',
            r['mins'] as int,
            (r['img'] as String?) ?? '',
          )..id = r['id'] as int)
      .toList();

  /// ข้ามการจองที่ผู้ใช้หรือเกมถูกลบไปแล้ว
  Future<List<B>> loadBookings(List<U> users, List<Game> games) async {
    final um = {for (final u in users) u.id: u};
    final gm = {for (final g in games) g.id: g};
    final out = <B>[];
    for (final r in await _d.query('bookings', orderBy: 'id')) {
      final u = um[r['user_id']], g = gm[r['game_id']];
      if (u == null || g == null) continue;
      out.add(B(
        u: u, g: g, ppl: r['ppl'] as int, full: r['is_full'] == 1,
        date: DateTime.parse(r['date'] as String),
        start: r['start_h'] as int, hours: r['hours'] as int,
        table: r['tbl'] as int, price: r['price'] as int, used: r['used'] as int,
      )
        ..id = r['id'] as int
        ..status = r['status'] as String);
    }
    return out;
  }

  Future<Map<U, List<M>>> loadChats(List<U> users) async {
    final um = {for (final u in users) u.id: u};
    final out = <U, List<M>>{};
    for (final r in await _d.query('messages', orderBy: 'id')) {
      final u = um[r['user_id']];
      if (u == null) continue;
      (out[u] ??= []).add(M(r['is_admin'] == 1, r['t'] as String));
    }
    return out;
  }

  Future<List<String>> loadNotes() async =>
      (await _d.query('notes', orderBy: 'id')).map((r) => r['t'] as String).toList();

  Future<Set<int>> loadClosed() async =>
      (await _d.query('closed_tables')).map((r) => r['tbl'] as int).toSet();
}