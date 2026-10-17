import 'package:flutter/material.dart';

void main() => runApp(const ArtboardApp());

// ═════════════════════════════════════════════════════════════
//  ARTBOARD · Design System  (Neo-Pop Dark)
//  ธีม: พื้นหลังม่วงเข้มยามค่ำ + ขอบสว่างหนา + เงาดำแข็ง (hard shadow)
//  สีหลักแดง / ฟ้า / เหลืองทอง   แก้สีทั้งแอปได้ที่ชุดค่าคงที่นี้ชุดเดียว
// ═════════════════════════════════════════════════════════════
const ink = Color(0xFFE8E1F5); // สีเส้นขอบ (สว่าง)
const dk = Color(0xFF15121C); // ตัวอักษร/ไอคอนบนพื้นสีสด (เหลือง ฟ้า ขาว)
const fg = Color(0xFFF5F0FF); // ตัวอักษรหลัก
const shd = Color(0xFF000000); // เงาแข็ง
const bg = Color(0xFF16131D); // พื้นหลัง
const bg2 = Color(0xFF1B1725); // พื้นช่องกรอกข้อมูล
const cardC = Color(0xFF221D2E); // พื้นการ์ด
const lineC = ink;
const sand = Color(0xFF332C44); // พื้นรอง (อวาตาร์/ปุ่มปิด)
const offC = Color(0xFF3A3448); // โต๊ะไม่ว่าง
const acc = Color(0xFFFF4D6A); // แดง (สีหลัก / โต๊ะที่เลือก)
const acc2 = Color(0xFF6DB3F2); // ฟ้า (โต๊ะว่าง)
const gold = Color(0xFFFFD23F); // เหลือง (ปุ่ม / ตัวเลือกที่เลือก)
const goldDk = Color(0xFFFFC93C); // เหลืองสำหรับตัวอักษรบนพื้นมืด
const violet = Color(0xFFA796FF);
const okC = Color(0xFF3DDBA0);
const badC = Color(0xFFFF6B7F);
const txt2 = Color(0xFFB8AFCB);
const txt3 = Color(0xFF8A819E);
const onAcc = dk;
const glowS = [Shadow(color: acc, offset: Offset(3, 3))];
const mono = TextStyle(letterSpacing: 1);

/// ใส่ความโปร่งใสให้สี
Color al(Color c, double o) => c.withAlpha((o * 255).round().clamp(0, 255));

/// กรอบการ์ดมาตรฐานของแอป (ขอบหนา + เงาแข็ง)
BoxDecoration neon({Color fill = cardC, Color border = lineC, double w = 2.2, double r = 16}) => BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: border, width: w),
      boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))],
    );

/// กล่องกดได้สไตล์ neo (ใช้ทำปุ่ม, ชิปวันที่, ชิปเวลา ฯลฯ)
Widget nb(Widget child,
        {Color fill = cardC, VoidCallback? onTap, double r = 12, EdgeInsets pad = EdgeInsets.zero, bool shadow = true}) =>
    Container(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: ink, width: 2.2),
        boxShadow: shadow ? const [BoxShadow(color: shd, offset: Offset(3, 3))] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(r),
        child: InkWell(borderRadius: BorderRadius.circular(r), onTap: onTap, child: Padding(padding: pad, child: child)),
      ),
    );

/// ใส่เงาแข็งให้ปุ่ม Material
Widget hard(Widget child, {double r = 14}) => Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(r), boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))]),
      child: child,
    );

final dlgShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: ink, width: 2.5));

/// พื้นหลังแอป: สีมืด + ลายจุด
class TechBg extends StatelessWidget {
  final Widget child;
  const TechBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: bg),
          CustomPaint(painter: _Grid()),
          child,
        ],
      );
}

class _Grid extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = const Color(0x0DFFFFFF);
    for (double x = 14; x < s.width; x += 26) {
      for (double y = 14; y < s.height; y += 26) {
        c.drawCircle(Offset(x, y), 1.1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

/// เส้นประรอบกล่อง (ใช้กับโต๊ะที่ไม่ว่าง)
class _DashedRRect extends CustomPainter {
  final Color c;
  const _DashedRRect(this.c);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(1.25, 1.25, s.width - 2.5, s.height - 2.5), const Radius.circular(14)));
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 6), p);
        d += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRect o) => o.c != c;
}

// ───────── Models ─────────
class Game {
  String name, desc, diff, img;
  int min, max, mins;
  Game(this.name, this.desc, this.min, this.max, this.diff, this.mins, [this.img = '']);
}

class U {
  String name, pass, phone, email;
  int pts = 0;
  bool photo = false, admin;
  U(this.name, this.pass, {this.phone = '', this.email = '', this.admin = false});
}

class B {
  int id = 0;
  String status = 'จองแล้ว';
  final U u;
  final Game g;
  final int ppl, start, hours, table, price, used;
  final bool full;
  final DateTime date;

  B({
    required this.u,
    required this.g,
    required this.ppl,
    required this.full,
    required this.date,
    required this.start,
    required this.hours,
    required this.table,
    required this.price,
    required this.used,
  });

  int get earn => price ~/ 35;
}

class M {
  bool admin;
  String t;
  M(this.admin, this.t);
}

bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
String fmtD(DateTime d) => '${d.day}/${d.month}/${d.year}';
String fmtT(int s, int h) => '${s.toString().padLeft(2, '0')}:00-${(s + h).toString().padLeft(2, '0')}:00';

// ───────── State Management (ตรรกะเดิมทั้งหมด) ─────────
class S extends ChangeNotifier {
  static final i = S._();
  S._();

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
    Game("อย่าซ่ากับบอส - I'm the boss!", 'เจรจาต่อรองปิดดีลธุรกิจ แย่งกันรวยที่สุด', 3, 6, 'ปานกลาง', 60),
    Game('โค้ดเนมส์ - Codenames', 'เกมทีมใบ้คำ ให้เพื่อนทายตามคำใบ้คำเดียว', 4, 8, 'ง่าย', 20),
    Game('เกมล่าแม่มด - Salem 1692', 'หาตัวแม่มดท่ามกลางชาวบ้านด้วยการกล่าวหา', 4, 12, 'ปานกลาง', 45),
    Game('วิ่งสู้ฟาสต์ - Magical Athlete', 'แข่งวิ่งด้วยพลังพิเศษสุดป่วนของนักกีฬา', 2, 6, 'ง่าย', 30),
    Game('ผู้ตรวจการณ์แห่งน็อตติงแฮม - Sheriff of Nottingham', 'เกมโกหกและต่อรองลักลอบนำสินค้าเข้าเมือง', 3, 5, 'ปานกลาง', 60),
    Game('สีสันบรรเทิง - Hues and Cues', 'ใบ้สีด้วยคำไม่เกินสองคำ แล้วให้เพื่อนวางหมุด', 3, 10, 'ง่าย', 40),
    Game('Splendor - เกมค้าเพชร', 'สะสมเพชรและการ์ดเพื่อสร้างอาณาจักรการค้า', 2, 4, 'ปานกลาง', 30),
    Game('Dead by daylight - เดธบายเดย์ไลท์', 'เกมหนีฆาตกรจากเกมดังบนโต๊ะ', 3, 5, 'ปานกลาง', 45),
    Game('ชีสหนูอยู่ไหน - Cheese Thieves', 'หนูขโมยชีสช่วยกันหาว่าใครคือสายลับ', 3, 8, 'ง่าย', 20),
    Game('แฟ้มคดีปริศนา - CS Files', 'ไขคดีปริศนาจากเบาะแสในแฟ้มคดี', 1, 6, 'ยาก', 90),
    Game('อวาลอน - Avalon', 'ฝ่ายคุณธรรมปะทะฝ่ายชั่วร้าย ซ่อนตัวตนและโหวตภารกิจ', 5, 10, 'ปานกลาง', 30),
    Game('บิดแล้วรวย', 'ประมูลแข่งกันเพื่อกอบโกยทรัพย์สิน', 3, 6, 'ง่าย', 30),
    Game('ดีลเดือดเชือดตลาดหุ้น - Wolf Street', 'เทรดหุ้นปั่นราคาแข่งกันเป็นเจ้าตลาด', 3, 6, 'ยาก', 60),
  ];

  void ping() => notifyListeners();

  bool free(int t, DateTime d, int s, int h, [B? ex]) {
    if (closed.contains(t)) return false;
    return !bookings.any((b) => b != ex && b.status != 'ยกเลิก' && b.table == t && sameDay(b.date, d) && s < b.start + b.hours && b.start < s + h);
  }

  void _revert(B b) => b.u.pts += b.used * 15 - b.earn;

  void save(B nb, B? old) {
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

  void cancel(B b) {
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

// ═════════════════════════════════════════════════════════════
//  Shared UI Components (แก้ธีมที่นี่ที่เดียว)
// ═════════════════════════════════════════════════════════════
Color diffColor(String d) => d == 'ง่าย' ? okC : (d == 'ยาก' ? badC : goldDk);

/// การ์ดกลาง: onTap เป็น optional
Widget card(Widget c, {EdgeInsets m = const EdgeInsets.symmetric(horizontal: 16, vertical: 6), VoidCallback? onTap}) => Container(
      margin: m,
      decoration: neon(),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(14), child: c),
        ),
      ),
    );

Widget tf(TextEditingController c, String l, {bool obscure = false, TextInputType? k, IconData? icon}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: obscure,
        keyboardType: k,
        decoration: InputDecoration(labelText: l, prefixIcon: icon == null ? null : Icon(icon, size: 20, color: txt2)),
      ),
    );

Widget chip(IconData i, String t, [Color c = acc2]) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: al(c, .14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: al(c, .7), width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(i, size: 14, color: c),
          const SizedBox(width: 5),
          Flexible(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        ],
      ),
    );

Widget pill(String t, Color c) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: al(c, .16), borderRadius: BorderRadius.circular(20), border: Border.all(color: al(c, .8), width: 1.4)),
      child: Text(t, style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800)),
    );

Widget emptyState(IconData i, String t) => Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(i, size: 52, color: txt3),
          const SizedBox(height: 12),
          Text(t, textAlign: TextAlign.center, style: const TextStyle(color: txt2)),
        ]),
      ),
    );

void snack(BuildContext c, String t) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(t)));

/// หัวข้อส่วน (แถบสีหน้าหัวข้อ + trailing ด้านขวา)
class Sec extends StatelessWidget {
  final String t;
  final Widget? trailing;
  const Sec(this.t, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
        child: Row(children: [
          Container(width: 5, height: 18, decoration: BoxDecoration(color: acc, borderRadius: BorderRadius.circular(2), border: Border.all(color: ink, width: 1.2))),
          const SizedBox(width: 10),
          Expanded(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
          if (trailing != null) trailing!,
        ]),
      );
}

/// แถบแต้มแบบเหรียญ (15 เหรียญ = แลกฟรี 1 ชม.)
class PipBar extends StatelessWidget {
  final int filled, total;
  final Color color;
  const PipBar(this.filled, {super.key, this.total = 15, this.color = gold});

  @override
  Widget build(BuildContext context) => Wrap(spacing: 5, runSpacing: 5, children: [
        for (var i = 0; i < total; i++)
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? color : al(ink, .08),
              border: Border.all(color: i < filled ? ink : al(ink, .3), width: 1.6),
            ),
          ),
      ]);
}

class Logo extends StatelessWidget {
  final double size;
  const Logo(this.size, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/images/logo.jpg',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * .28),
              color: acc,
              border: Border.all(color: ink, width: 2.2),
              boxShadow: const [BoxShadow(color: shd, offset: Offset(2, 2))],
            ),
            child: Center(child: Icon(Icons.casino_rounded, color: Colors.white, size: size * .56)),
          ),
        ),
      );
}

class GameImg extends StatelessWidget {
  final Game g;
  final double size;
  const GameImg(this.g, {super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final c = diffColor(g.diff);
    final inner = Container(color: sand, child: Center(child: Icon(Icons.extension_rounded, color: c, size: size * .46)));
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: ink, width: 2.2)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.5),
        child: g.img.isEmpty
            ? inner
            : Image.asset(g.img, width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) => inner),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Game g;
  final VoidCallback? onTap;
  final Widget? trailing;
  const GameCard(this.g, {super.key, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) => card(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GameImg(g),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(g.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, height: 1.25))),
                if (trailing != null) trailing!,
              ]),
              const SizedBox(height: 5),
              Text(g.desc, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: txt2, fontSize: 13, height: 1.35)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 6, children: [
                chip(Icons.group_rounded, '${g.min}-${g.max} คน'),
                chip(Icons.bolt_rounded, g.diff, diffColor(g.diff)),
                chip(Icons.timer_rounded, '${g.mins} นาที', violet),
              ]),
            ]),
          ),
        ]),
        onTap: onTap,
      );
}

// ───────── Main Application Configuration ─────────
class ArtboardApp extends StatelessWidget {
  const ArtboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    RoundedRectangleBorder r(double v) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(v));
    OutlineInputBorder ib(Color c, [double w = 2]) => OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamilyFallback: const ['Kanit', 'Prompt', 'Noto Sans Thai', 'Sarabun'],
      colorScheme: const ColorScheme.dark(
        primary: acc,
        onPrimary: Colors.white,
        secondary: acc2,
        onSecondary: dk,
        surface: cardC,
        onSurface: fg,
        secondaryContainer: gold,
        onSecondaryContainer: dk,
        outline: ink,
        error: badC,
      ),
    );
    return MaterialApp(
      title: 'ARTBOARD',
      debugShowCheckedModeBanner: false,
      // จำกัดความกว้างเนื้อหาบนจอใหญ่ (แท็บเล็ต/เว็บ) พื้นหลังยังเต็มจอ
      builder: (c, child) => TechBg(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: al(ink, .15), width: 1.5))),
              child: child!,
            ),
          ),
        ),
      ),
      theme: base.copyWith(
        textTheme: base.textTheme.apply(bodyColor: fg, displayColor: fg),
        scaffoldBackgroundColor: Colors.transparent,
        dividerTheme: DividerThemeData(color: al(ink, .3), thickness: 1.5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: fg,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: .5, color: fg),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: dk,
            disabledBackgroundColor: sand,
            disabledForegroundColor: txt3,
            minimumSize: const Size(0, 48),
            side: const BorderSide(color: ink, width: 2.5),
            textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
            shape: r(14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46), foregroundColor: fg, side: const BorderSide(color: ink, width: 2), shape: r(14)),
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: acc, textStyle: const TextStyle(fontWeight: FontWeight.w800))),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: SegmentedButton.styleFrom(
            side: const BorderSide(color: ink, width: 2),
            foregroundColor: fg,
            backgroundColor: cardC,
            selectedBackgroundColor: gold,
            selectedForegroundColor: dk,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF3A3350),
          contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: ink, width: 1.5)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: bg2,
          labelStyle: const TextStyle(color: txt2),
          hintStyle: const TextStyle(color: txt3),
          border: ib(lineC),
          enabledBorder: ib(lineC),
          focusedBorder: ib(acc, 2.4),
        ),
      ),
      home: const Login(),
    );
  }
}

void enter(BuildContext c, U u) {
  S.i.me = u;
  Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => u.admin ? const AdminHome() : const Home()), (r) => false);
}

void logout(BuildContext c) {
  S.i.me = null;
  Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => const Login()), (r) => false);
}

// ───────── Authentication Screens ─────────
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final n = TextEditingController(), p = TextEditingController();

  @override
  void dispose() {
    n.dispose();
    p.dispose();
    super.dispose();
  }

  void _submit() {
    final matches = S.i.users.where((x) => x.name == n.text.trim() && x.pass == p.text).toList();
    final u = matches.isNotEmpty ? matches.first : null;
    u == null ? snack(context, 'ชื่อหรือรหัสผ่านไม่ถูกต้อง') : enter(context, u);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(children: [
                  const Logo(112),
                  const SizedBox(height: 18),
                  const Text('ARTBOARD', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 5, shadows: glowS)),
                  const SizedBox(height: 4),
                  const Text('Board Game Cafe', style: TextStyle(color: gold, letterSpacing: 2, fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 28),
                  card(
                    Column(children: [
                      tf(n, 'ชื่อผู้ใช้', icon: Icons.person_outline),
                      tf(p, 'รหัสผ่าน', obscure: true, icon: Icons.lock_outline),
                      SizedBox(width: double.infinity, height: 50, child: hard(FilledButton(onPressed: _submit, child: const Text('เข้าสู่ระบบ')))),
                    ]),
                    m: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())), child: const Text('ยังไม่มีบัญชี? ลงทะเบียน')),
                  const Text('แอดมินทดลอง: admin / admin', style: TextStyle(color: txt3, fontSize: 11)),
                ]),
              ),
            ),
          ),
        ),
      );
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final n = TextEditingController(), ph = TextEditingController(), em = TextEditingController(), p = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียน')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 14),
          child: Text('สร้างบัญชีใหม่ เพื่อจองโต๊ะและสะสมแต้ม', style: TextStyle(color: txt2)),
        ),
        card(
          Column(children: [
            tf(n, 'ชื่อ', icon: Icons.person_outline),
            tf(ph, 'เบอร์โทร', k: TextInputType.phone, icon: Icons.phone_outlined),
            tf(em, 'อีเมล', k: TextInputType.emailAddress, icon: Icons.mail_outline),
            tf(p, 'รหัสผ่าน', obscure: true, icon: Icons.lock_outline),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: hard(FilledButton(
                onPressed: () {
                  final name = n.text.trim();
                  if (name.isEmpty || ph.text.trim().length < 9 || !em.text.contains('@') || p.text.length < 4) {
                    return snack(context, 'กรอกข้อมูลให้ครบ (เบอร์ ≥ 9 หลัก, อีเมลถูกต้อง, รหัส ≥ 4 ตัว)');
                  }
                  if (S.i.users.any((x) => x.name == name)) return snack(context, 'ชื่อนี้ถูกใช้แล้ว');
                  final u = U(name, p.text, phone: ph.text.trim(), email: em.text.trim());
                  S.i.users.add(u);
                  enter(context, u);
                },
                child: const Text('สมัครสมาชิก'),
              )),
            ),
          ]),
          m: EdgeInsets.zero,
        ),
      ]),
    );
  }
}

// ───────── Customer Views ─────────
class SubPage extends StatelessWidget {
  final String title;
  final Widget body;
  const SubPage(this.title, this.body, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: AnimatedBuilder(animation: S.i, builder: (_, __) => body));
}

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

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        Sec('บอร์ดเกมทั้งหมด', trailing: Text('${S.i.games.length} เกม', style: const TextStyle(color: txt2, fontSize: 13))),
        for (final g in S.i.games) GameCard(g),
      ]);
}

class BookTab extends StatelessWidget {
  const BookTab({super.key});

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('เลือกบอร์ดเกมที่อยากเล่น'),
        for (final g in S.i.games) GameCard(g, trailing: const Icon(Icons.chevron_right, color: acc), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(g)))),
      ]);
}

// ═════════════════════════════════════════════════════════════
//  หน้าจองโต๊ะ (ดีไซน์ตามภาพ — ตรรกะเดิมทั้งหมด)
// ═════════════════════════════════════════════════════════════
class BookPage extends StatefulWidget {
  final Game g;
  final B? edit;
  const BookPage(this.g, {super.key, this.edit});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late int ppl = widget.edit?.ppl ?? 2, start = widget.edit?.start ?? 18, hours = widget.edit?.hours ?? 2;
  late bool full = widget.edit?.full ?? false, redeem = (widget.edit?.used ?? 0) > 0;
  late DateTime date = widget.edit?.date ?? DateTime.now();
  int? table;

  // รายการวัน: วันนี้ → +60 วัน (ถ้าแก้ไขการจองที่เป็นวันเก่า จะเริ่มจากวันนั้น)
  late final DateTime _today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late final DateTime _first = date.isBefore(_today) ? DateTime(date.year, date.month, date.day) : _today;
  late final List<DateTime> days = () {
    final last = DateTime(_today.year, _today.month, _today.day + 60);
    final out = <DateTime>[];
    var d = _first;
    while (!d.isAfter(last)) {
      out.add(d);
      d = DateTime(d.year, d.month, d.day + 1);
    }
    return out;
  }();
  late final ScrollController dayCtrl = ScrollController(
    initialScrollOffset: () {
      final idx = days.indexWhere((d) => sameDay(d, date));
      return idx <= 0 ? 0.0 : idx * 68.0;
    }(),
  );

  @override
  void dispose() {
    dayCtrl.dispose();
    super.dispose();
  }

  int get s => full ? 10 : start;
  int get h => full ? 12 : hours;
  int get base => full ? 135 * ppl : 35 * hours * ppl;
  int get disc => redeem ? 35 : 0;
  int get avail {
    final e = widget.edit;
    return S.i.me!.pts + (e != null && e.status != 'ยกเลิก' ? e.used * 15 - e.earn : 0);
  }

  void fix() {
    if (table != null && !S.i.free(table!, date, s, h, widget.edit)) table = null;
    if (avail < 15) redeem = false;
    setState(() {});
  }

  // ── UI helpers ──
  Widget lbl(String t, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(children: [
          Expanded(child: Text(t, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
          if (trailing != null) trailing,
        ]),
      );

  Widget sq(IconData i, VoidCallback? on) => SizedBox(
        width: 38,
        height: 38,
        child: nb(Center(child: Icon(i, size: 20, color: on == null ? txt3 : dk)), fill: on == null ? sand : gold, onTap: on, r: 10, shadow: on != null),
      );

  Widget stepper(int v, int lo, int hi, ValueChanged<int> f, String unit) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          sq(Icons.remove, v > lo ? () => f(v - 1) : null),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$v $unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
          sq(Icons.add, v < hi ? () => f(v + 1) : null),
        ],
      );

  Widget gamePill(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: dk, width: 1.5)),
        child: Text(t, style: const TextStyle(color: dk, fontSize: 12, fontWeight: FontWeight.w700)),
      );

  Widget gameHeader() => Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 19, 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: acc,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ink, width: 2.5),
          boxShadow: const [BoxShadow(color: shd, offset: Offset(4, 4))],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          GameImg(widget.g, size: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.g.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17, height: 1.2)),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                gamePill('${widget.g.min}-${widget.g.max} คน'),
                gamePill(widget.g.diff),
                gamePill('${widget.g.mins} นาที'),
              ]),
            ]),
          ),
        ]),
      );

  Widget dayChip(DateTime d) {
    const wd = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];
    final sel = sameDay(d, date);
    final tc = sel ? dk : fg;
    return SizedBox(
      width: 58,
      child: nb(
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${d.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: tc)),
              Text(wd[d.weekday - 1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tc)),
            ]),
          ),
        ),
        fill: sel ? gold : cardC,
        onTap: () {
          date = d;
          fix();
        },
        r: 14,
        pad: const EdgeInsets.symmetric(vertical: 6),
      ),
    );
  }

  Widget timeChip(int t) {
    final sel = start == t;
    return SizedBox(
      width: 78,
      height: 42,
      child: nb(
        Center(child: Text('${t.toString().padLeft(2, '0')}:00', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: sel ? dk : fg))),
        fill: sel ? gold : cardC,
        onTap: () {
          start = t;
          if (start + hours > 22) hours = 22 - start;
          fix();
        },
        r: 12,
      ),
    );
  }

  Widget tableTile(int t) {
    final isClosed = S.i.closed.contains(t);
    final ok = S.i.free(t, date, s, h, widget.edit);
    final sel = table == t;
    final fill = sel ? acc : (ok ? acc2 : offC);
    final tc = sel ? Colors.white : (ok ? dk : txt3);
    final status = sel ? 'เลือกแล้ว' : (isClosed ? 'ปิดใช้งาน' : (ok ? 'ว่าง' : 'ไม่ว่าง'));
    final r = BorderRadius.circular(14);
    Widget body = Container(
      constraints: const BoxConstraints(minHeight: 72),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: ok
          ? BoxDecoration(color: fill, borderRadius: r, border: Border.all(color: ink, width: 2.5), boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))])
          : BoxDecoration(color: fill, borderRadius: r),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('โต๊ะ $t', style: TextStyle(color: tc, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 2),
          Text(status, style: TextStyle(color: tc, fontSize: 11.5, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
    if (!ok) body = CustomPaint(foregroundPainter: const _DashedRRect(txt3), child: body);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (ok) {
          setState(() => table = t);
        } else {
          snack(context, isClosed ? 'โต๊ะ $t ปิดใช้งานอยู่' : 'โต๊ะ $t ไม่ว่างในช่วงเวลานี้ กรุณาเลือกโต๊ะหรือเวลาอื่น');
        }
      },
      child: body,
    );
  }

  Widget legendItem(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3), border: Border.all(color: ink, width: 2)),
        ),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
      ]);

  @override
  Widget build(BuildContext context) {
    final freeCount = [1, 2, 3].where((t) => S.i.free(t, date, s, h, widget.edit)).length;
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.only(bottom: 30), children: [
          // ── หัวข้อ + ปุ่มย้อนกลับ ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(children: [
              SizedBox(
                width: 44,
                height: 44,
                child: nb(const Center(child: Icon(Icons.arrow_back_ios_new_rounded, size: 18)), onTap: () => Navigator.maybePop(context), r: 12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(widget.edit == null ? 'จองโต๊ะ' : 'แก้ไขการจอง #${widget.edit!.id}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              ),
            ]),
          ),
          gameHeader(),

          // ── ผู้เล่นและรูปแบบเวลา ──
          lbl('ผู้เล่นและรูปแบบเวลา'),
          card(Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('จำนวนคน', style: TextStyle(fontWeight: FontWeight.w700)),
              stepper(ppl, 1, 12, (v) {
                ppl = v;
                fix();
              }, 'คน'),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [ButtonSegment(value: false, label: Text('รายชั่วโมง')), ButtonSegment(value: true, label: Text('เหมาทั้งวัน'))],
                selected: {full},
                onSelectionChanged: (v) {
                  full = v.first;
                  fix();
                },
              ),
            ),
          ])),

          // ── วันที่ ──
          lbl('วันที่', trailing: Text(fmtD(date), style: const TextStyle(color: txt2, fontWeight: FontWeight.w700))),
          SizedBox(
            height: 76,
            child: ListView.separated(
              controller: dayCtrl,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => dayChip(days[i]),
            ),
          ),

          // ── เวลา ──
          lbl('เวลา'),
          if (!full) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 19, 4),
              child: Wrap(spacing: 10, runSpacing: 12, children: [for (var t = 10; t < 22; t++) timeChip(t)]),
            ),
            card(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('จำนวนชั่วโมง', style: TextStyle(fontWeight: FontWeight.w700)),
              stepper(hours, 1, 22 - start, (v) {
                hours = v;
                fix();
              }, 'ชม.'),
            ])),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text('เวลาใช้โต๊ะ ${fmtT(start, hours)}', style: const TextStyle(color: txt2, fontSize: 12.5)),
            ),
          ] else
            card(const Row(children: [
              Icon(Icons.schedule, color: acc),
              SizedBox(width: 10),
              Expanded(child: Text('เหมาวัน: 10:00-22:00', style: TextStyle(fontWeight: FontWeight.w700))),
            ])),

          // ── เลือกโต๊ะ ──
          lbl('เลือกโต๊ะ', trailing: Text('โต๊ะที่ว่าง $freeCount / 3 โต๊ะ', style: const TextStyle(color: txt2, fontSize: 13))),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(12, 14, 15, 15),
            decoration: BoxDecoration(color: cardC, borderRadius: BorderRadius.circular(20), border: Border.all(color: ink, width: 2.5)),
            child: Row(children: [
              for (final t in [1, 2, 3]) ...[
                if (t > 1) const SizedBox(width: 12),
                Expanded(child: tableTile(t)),
              ],
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Wrap(alignment: WrapAlignment.center, spacing: 26, runSpacing: 8, children: [
              legendItem(acc2, 'ว่าง'),
              legendItem(offC, 'ไม่ว่าง'),
              legendItem(acc, 'ที่เลือก'),
            ]),
          ),

          // ── แลกแต้ม ──
          if (avail >= 15)
            card(SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('ใช้ 15 แต้ม แลกฟรี 1 ชั่วโมง (-35 บาท)', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('แต้มคงเหลือ $avail'),
              value: redeem,
              onChanged: (v) {
                redeem = v;
                fix();
              },
            )),

          // ── ราคา ──
          lbl('รายละเอียดราคา'),
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('• รายชั่วโมง 35 บาท / คน / ชั่วโมง', style: TextStyle(color: txt2)),
            const SizedBox(height: 2),
            const Text('• เหมาวัน 135 บาท / คน', style: TextStyle(color: txt2)),
            const Divider(height: 22),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Expanded(child: Text('ราคาที่ต้องชำระ', style: TextStyle(fontWeight: FontWeight.w700))),
              Text('${base - disc} บาท', style: const TextStyle(color: goldDk, fontSize: 22, fontWeight: FontWeight.w900)),
            ]),
          ])),

          // ── ปุ่มยืนยัน ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 19, 8),
            child: SizedBox(
              height: 56,
              child: nb(
                Center(child: Text(table == null ? 'เลือกโต๊ะก่อนยืนยัน' : 'ยืนยันการจอง', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: dk))),
                fill: gold,
                r: 16,
                onTap: () {
                  if (table == null) {
                    snack(context, 'กรุณาเลือกโต๊ะก่อนยืนยันการจอง');
                    return;
                  }
                  final b = B(u: S.i.me!, g: widget.g, ppl: ppl, full: full, date: date, start: s, hours: h, table: table!, price: base - disc, used: redeem ? 1 : 0);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Summary(b, widget.edit)));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class Summary extends StatelessWidget {
  final B b;
  final B? old;
  const Summary(this.b, this.old, {super.key});

  Widget row(String a, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(a, style: const TextStyle(color: txt2)),
            const SizedBox(width: 16),
            Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700))),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final o = old;
    final after = b.u.pts + (o != null && o.status != 'ยกเลิก' ? o.used * 15 - o.earn : 0) + b.earn - b.used * 15;
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปการจอง')),
      body: ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        card(Column(children: [
          row('บอร์ดเกม', b.g.name),
          row('จำนวนผู้เล่น', '${b.ppl} คน'),
          row('วันที่', fmtD(b.date)),
          row('เวลา', fmtT(b.start, b.hours)),
          row('จำนวนชั่วโมง', b.full ? 'เหมาวัน' : '${b.hours} ชม.'),
          row('โต๊ะ', 'โต๊ะ ${b.table}'),
          if (b.used > 0) row('ส่วนลดแลกแต้ม', '-35 บาท'),
          const Divider(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Expanded(child: Text('ราคาที่ต้องชำระ', style: TextStyle(fontWeight: FontWeight.w700))),
            Text('${b.price} บาท', style: const TextStyle(color: goldDk, fontSize: 22, fontWeight: FontWeight.w900)),
          ]),
          row('แต้มที่จะได้รับ', '+${b.earn} แต้ม'),
        ])),
        card(Row(children: [
          const Icon(Icons.toll_rounded, color: goldDk, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('คุณจะได้รับ +${b.earn} แต้ม', style: const TextStyle(color: goldDk, fontSize: 19, fontWeight: FontWeight.w900)),
              Text('(${b.price} บาท ÷ 35 = ${b.earn} แต้ม)', style: const TextStyle(color: txt2, fontSize: 12)),
              if (b.used > 0) const Text('ใช้แต้มแลกฟรี 1 ชม.: -15 แต้ม', style: TextStyle(color: txt2, fontSize: 12)),
              const SizedBox(height: 2),
              Text('แต้มสะสมหลังจองเสร็จ: $after แต้ม', style: const TextStyle(fontSize: 13)),
            ]),
          ),
        ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 19, 16),
          child: SizedBox(
            height: 54,
            child: hard(FilledButton(
              onPressed: () {
                final m = ScaffoldMessenger.of(context);
                S.i.save(b, old);
                Navigator.popUntil(context, (r) => r.isFirst);
                m.showSnackBar(SnackBar(content: Text('บันทึกการจองแล้ว ได้รับ ${b.earn} แต้ม')));
              },
              child: const Text('ยืนยันการจอง'),
            )),
          ),
        ),
      ]),
    );
  }
}

class PointsTab extends StatelessWidget {
  const PointsTab({super.key});

  Widget step(IconData i, String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(i, size: 18, color: goldDk),
          const SizedBox(width: 10),
          Expanded(child: Text(t, style: const TextStyle(height: 1.3))),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final p = S.i.me!.pts;
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      card(Column(children: [
        const Text('แต้มสะสมของคุณ', style: TextStyle(color: txt2)),
        Text('$p', style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900, color: gold, height: 1.1, shadows: [Shadow(color: shd, offset: Offset(3, 3))])),
        const SizedBox(height: 6),
        Center(child: PipBar(p >= 15 ? 15 : p)),
        const SizedBox(height: 12),
        Text(p >= 15 ? 'แลกเล่นฟรี 1 ชั่วโมงได้แล้ว! (ตอนจอง)' : 'อีก ${15 - p} แต้ม แลกฟรี 1 ชั่วโมง', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
      ])),
      const Sec('วิธีสะสมแต้ม'),
      card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        step(Icons.payments_outlined, 'ทุก 35 บาท ได้ 1 แต้ม (คำนวณอัตโนมัติหลังจอง)'),
        step(Icons.photo_camera_outlined, 'ลงสตอรี่แท็กร้าน ได้เพิ่ม 1 แต้ม (แจ้งแอดมิน)'),
        step(Icons.redeem_outlined, 'สะสมครบ 15 แต้ม แลกฟรี 1 ชั่วโมง'),
      ])),
    ]);
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.i.bookings.where((b) => b.u == S.i.me).toList().reversed.toList();
    if (l.isEmpty) return emptyState(Icons.event_busy_outlined, 'ยังไม่มีประวัติการจอง');
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      for (final b in l)
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Text('#${b.id} ${b.g.name}', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800))),
            const SizedBox(width: 8),
            pill(b.status, b.status == 'ยกเลิก' ? badC : okC),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 6, children: [
            chip(Icons.calendar_month, fmtD(b.date)),
            chip(Icons.schedule, fmtT(b.start, b.hours), violet),
            chip(Icons.table_restaurant, 'โต๊ะ ${b.table} · ${b.ppl} คน', acc),
          ]),
          const SizedBox(height: 8),
          Text('${b.price} บาท • +${b.earn} แต้ม', style: const TextStyle(color: goldDk, fontWeight: FontWeight.w800)),
          if (b.status != 'ยกเลิก')
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(b.g, edit: b))), child: const Text('แก้ไข')),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (d) => AlertDialog(
                    backgroundColor: cardC,
                    shape: dlgShape,
                    title: const Text('ยกเลิกการจอง?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(d), child: const Text('ไม่')),
                      FilledButton(
                        onPressed: () {
                          S.i.cancel(b);
                          Navigator.pop(d);
                        },
                        child: const Text('ยกเลิกการจอง'),
                      )
                    ],
                  ),
                ),
                child: const Text('ยกเลิก', style: TextStyle(color: badC)),
              ),
            ]),
        ])),
    ]);
  }
}

// ───────── Profile & Settings ─────────
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void edit(BuildContext c, String title, String init, void Function(String) ok) {
    final t = TextEditingController(text: init);
    showDialog(
      context: c,
      builder: (d) => AlertDialog(
        backgroundColor: cardC,
        shape: dlgShape,
        title: Text('แก้ไข $title'),
        content: TextField(controller: t, decoration: InputDecoration(labelText: title)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () {
              ok(t.text.trim());
              S.i.ping();
              Navigator.pop(d);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = S.i.me!;
    return ListView(padding: const EdgeInsets.symmetric(vertical: 12), children: [
      Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, color: gold, border: Border.all(color: ink, width: 2.5), boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))]),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: u.photo ? acc : sand,
              child: Icon(Icons.person, size: 48, color: u.photo ? Colors.white : txt2),
            ),
          ),
          const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(u.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
          const SizedBox(height: 4),
          pill('${u.pts} แต้มสะสม', goldDk),
        ]),
      ),
      const SizedBox(height: 16),
      card(Column(children: [
        ListTile(
          leading: const Icon(Icons.phone_outlined, color: acc2),
          title: const Text('เบอร์โทรศัพท์'),
          subtitle: Text(u.phone.isEmpty ? 'ยังไม่ระบุ' : u.phone),
          trailing: const Icon(Icons.edit, size: 18),
          onTap: () => edit(context, 'เบอร์โทรศัพท์', u.phone, (v) => u.phone = v),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.mail_outline, color: acc2),
          title: const Text('อีเมล'),
          subtitle: Text(u.email.isEmpty ? 'ยังไม่ระบุ' : u.email, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.edit, size: 18),
          onTap: () => edit(context, 'อีเมล', u.email, (v) => u.email = v),
        ),
      ])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(foregroundColor: badC, side: const BorderSide(color: badC, width: 2)),
          onPressed: () => logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('ออกจากระบบ'),
        ),
      ),
    ]);
  }
}

// ───────── Admin & Chat Components ─────────
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int tab = 0;

  Widget _stat(String label, String value, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: neon(),
          child: Column(children: [
            Text(value, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: color)),
            Text(label, style: const TextStyle(fontSize: 12, color: txt2)),
          ]),
        ),
      );

  void _notifications(BuildContext context) {
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

  void _addGame(BuildContext context) {
    final name = TextEditingController();
    final desc = TextEditingController();
    final min = TextEditingController(text: '2');
    final max = TextEditingController(text: '6');
    final mins = TextEditingController(text: '30');
    String diff = 'ง่าย';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, refresh) => AlertDialog(
        backgroundColor: cardC,
        shape: dlgShape,
        title: const Text('เพิ่มบอร์ดเกม'),
        content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          tf(name, 'ชื่อเกม'),
          tf(desc, 'รายละเอียดเกม'),
          Row(children: [
            Expanded(child: tf(min, 'คนต่ำสุด', k: TextInputType.number)),
            const SizedBox(width: 8),
            Expanded(child: tf(max, 'คนสูงสุด', k: TextInputType.number)),
          ]),
          tf(mins, 'เวลา (นาที)', k: TextInputType.number),
          DropdownButtonFormField<String>(
            value: diff,
            decoration: const InputDecoration(labelText: 'ระดับความยาก'),
            items: const [
              DropdownMenuItem(value: 'ง่าย', child: Text('ง่าย')),
              DropdownMenuItem(value: 'ปานกลาง', child: Text('ปานกลาง')),
              DropdownMenuItem(value: 'ยาก', child: Text('ยาก')),
            ],
            onChanged: (v) => refresh(() => diff = v ?? 'ง่าย'),
          ),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () {
              final lo = int.tryParse(min.text) ?? 0;
              final hi = int.tryParse(max.text) ?? 0;
              final duration = int.tryParse(mins.text) ?? 0;
              if (name.text.trim().isEmpty || lo < 1 || hi < lo || duration < 1) {
                snack(context, 'กรุณากรอกข้อมูลเกมให้ถูกต้อง');
                return;
              }
              S.i.games.add(Game(name.text.trim(), desc.text.trim(), lo, hi, diff, duration));
              S.i.notes.add('🎲 เพิ่มเกม ${name.text.trim()}');
              S.i.ping();
              Navigator.pop(ctx);
            },
            child: const Text('บันทึกเกม'),
          ),
        ],
      )),
    ).then((_) {
      name.dispose(); desc.dispose(); min.dispose(); max.dispose(); mins.dispose();
    });
  }

  Widget _tables() => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('แผนผังโต๊ะ (ตอนนี้) — แตะเพื่อปิด/เปิดโต๊ะ'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            for (int t = 1; t <= 3; t++) ...[
              if (t > 1) const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (S.i.closed.contains(t)) {
                        S.i.closed.remove(t);
                      } else {
                        S.i.closed.add(t);
                      }
                    });
                    S.i.notes.add('${S.i.closed.contains(t) ? "🔒 ปิด" : "🪑 เปิด"}โต๊ะ $t');
                    S.i.ping();
                  },
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 150),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                    decoration: BoxDecoration(
                      color: S.i.closed.contains(t) ? offC : cardC,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: S.i.closed.contains(t) ? txt3 : acc2, width: 2.4),
                      boxShadow: const [BoxShadow(color: shd, offset: Offset(3, 3))],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.table_restaurant_rounded, size: 35, color: S.i.closed.contains(t) ? txt3 : acc2),
                      const SizedBox(height: 8),
                      Text('โต๊ะ $t', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      const SizedBox(height: 3),
                      Text(S.i.closed.contains(t) ? 'ปิดใช้งาน' : 'เปิดใช้งาน',
                          style: TextStyle(color: S.i.closed.contains(t) ? badC : okC, fontWeight: FontWeight.w700, fontSize: 12)),
                    ]),
                  ),
                ),
              ),
            ],
          ]),
        ),
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('สถานะการใช้งาน', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          for (int t = 1; t <= 3; t++)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(Icons.table_restaurant, color: S.i.closed.contains(t) ? badC : okC),
              title: Text('โต๊ะ $t'),
              subtitle: Text(S.i.closed.contains(t) ? 'ปิดรับจอง' : 'เปิดรับจอง'),
              value: !S.i.closed.contains(t),
              onChanged: (open) {
                if (open) { S.i.closed.remove(t); } else { S.i.closed.add(t); }
                S.i.ping();
              },
            ),
        ])),
      ]);

  Widget _bookings() {
    final all = S.i.bookings;
    final active = all.where((b) => b.status != 'ยกเลิก').length;
    return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
      const Sec('คิวจองทั้งหมด'),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Row(children: [
          _stat('ทั้งหมด', '${all.length}', acc2),
          const SizedBox(width: 8),
          _stat('จองอยู่', '$active', okC),
          const SizedBox(width: 8),
          _stat('ยกเลิก', '${all.length - active}', badC),
        ]),
      ),
      if (all.isEmpty) emptyState(Icons.event_busy_outlined, 'ไม่มีรายการจอง'),
      for (final b in all.reversed)
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('#${b.id}  ${b.u.name}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 4),
          Text(b.g.name, style: const TextStyle(color: txt2)),
          const SizedBox(height: 10),
          Wrap(spacing: 7, runSpacing: 7, children: [
            chip(Icons.table_restaurant, 'โต๊ะ ${b.table}'),
            chip(Icons.calendar_month, fmtD(b.date), violet),
            chip(Icons.schedule, fmtT(b.start, b.hours), goldDk),
            chip(Icons.group, '${b.ppl} คน', acc),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: pill('สถานะ: ${b.status}', b.status == 'ยกเลิก' ? badC : okC)),
            Text('${b.price} บาท', style: const TextStyle(color: goldDk, fontWeight: FontWeight.w900)),
            if (b.status == 'จองแล้ว')
              IconButton(tooltip: 'ยกเลิกการจอง', icon: const Icon(Icons.cancel_outlined, color: badC), onPressed: () => S.i.cancel(b)),
          ]),
        ])),
    ]);
  }

  Widget _games() => ListView(padding: const EdgeInsets.only(bottom: 90), children: [
        Sec('บอร์ดเกมในร้าน', trailing: Text('${S.i.games.length} เกม', style: const TextStyle(color: txt2, fontSize: 13))),
        for (final g in S.i.games) GameCard(g),
      ]);

  Widget _points(List<U> customers) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('แต้มสะสมลูกค้า'),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text('กด + เพื่อเพิ่มแต้ม หรือ − เพื่อลดแต้ม', style: TextStyle(color: txt2, fontSize: 12.5)),
        ),
        for (final u in customers)
          card(Row(children: [
            const CircleAvatar(backgroundColor: sand, child: Icon(Icons.person, color: acc2)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(u.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 4),
              Text('แต้มสะสม: ${u.pts} แต้ม', style: const TextStyle(color: goldDk, fontWeight: FontWeight.w700)),
            ])),
            IconButton(tooltip: 'ลด 1 แต้ม', icon: const Icon(Icons.remove_circle_outline, color: violet),
              onPressed: () => u.pts > 0 ? S.i.adjustPts(u, -1) : snack(context, '${u.name} ไม่มีแต้มให้ลด')),
            IconButton(tooltip: 'เพิ่ม 1 แต้ม', icon: const Icon(Icons.add_circle, color: acc2),
              onPressed: () => S.i.adjustPts(u, 1)),
          ])),
      ]);

  Widget _chats(List<U> customers) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
        const Sec('แชทลูกค้า'),
        for (final u in customers)
          card(ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(backgroundColor: sand, child: Icon(Icons.person, color: acc2)),
            title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w900)),
            subtitle: Text((S.i.chats[u]?.isNotEmpty ?? false) ? S.i.chats[u]!.last.t : 'ข้อความล่าสุด: ไม่มีการสนทนา',
                maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right, color: acc2, size: 28),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(u, true))),
          )),
      ]);

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: S.i,
        builder: (_, __) {
          final customers = S.i.users.where((u) => !u.admin).toList();
          final pages = [_tables(), _bookings(), _games(), _points(customers), _chats(customers)];
          return Scaffold(
            appBar: AppBar(
              title: const Row(children: [
                Logo(34),
                SizedBox(width: 10),
                Flexible(child: Text('ARTBOARD  ADMIN', overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5))),
              ]),
              actions: [
                IconButton(tooltip: 'แจ้งเตือน', icon: const Icon(Icons.notifications_none_rounded), onPressed: () => _notifications(context)),
                IconButton(tooltip: 'ออกจากระบบ', icon: const Icon(Icons.logout_rounded), onPressed: () => logout(context)),
                const SizedBox(width: 4),
              ],
            ),
            body: IndexedStack(index: tab, children: pages),
            floatingActionButton: tab == 2
                ? FloatingActionButton.extended(
                    onPressed: () => _addGame(context),
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

class ChatPage extends StatefulWidget {
  final U targetUser;
  final bool isAdmin;
  const ChatPage(this.targetUser, this.isAdmin, {super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final msgCtrl = TextEditingController();
  final scroll = ScrollController();

  @override
  void dispose() {
    msgCtrl.dispose();
    scroll.dispose();
    super.dispose();
  }

  void _send(List<M> list) {
    if (msgCtrl.text.trim().isEmpty) return;
    list.add(M(widget.isAdmin, msgCtrl.text.trim()));
    msgCtrl.clear();
    S.i.ping();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) scroll.animateTo(scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = S.i.chats.putIfAbsent(widget.targetUser, () => []);
    final maxBubble = (MediaQuery.of(context).size.width * .78).clamp(0.0, 520.0).toDouble();
    return Scaffold(
      appBar: AppBar(title: Text('แชทกับ ${widget.isAdmin ? widget.targetUser.name : "แอดมิน"}', maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: Column(children: [
        Expanded(
          child: AnimatedBuilder(
            animation: S.i,
            builder: (_, __) => list.isEmpty
                ? emptyState(Icons.forum_outlined, 'ยังไม่มีข้อความ เริ่มสนทนาได้เลย')
                : ListView.builder(
                    controller: scroll,
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (_, idx) {
                      final m = list[idx];
                      final isMe = widget.isAdmin ? m.admin : !m.admin;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxBubble),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe ? gold : cardC,
                            border: Border.all(color: ink, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 4),
                              bottomRight: Radius.circular(isMe ? 4 : 16),
                            ),
                            boxShadow: const [BoxShadow(color: shd, offset: Offset(2, 2))],
                          ),
                          child: Text(m.t, style: TextStyle(height: 1.3, fontWeight: FontWeight.w500, color: isMe ? dk : fg)),
                        ),
                      );
                    },
                  ),
          ),
        ),
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(color: cardC, border: Border(top: BorderSide(color: lineC, width: 2))),
            child: Row(children: [
              Expanded(child: TextField(controller: msgCtrl, onSubmitted: (_) => _send(list), decoration: const InputDecoration(hintText: 'พิมพ์ข้อความ...'))),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: acc, foregroundColor: Colors.white),
                icon: const Icon(Icons.send),
                onPressed: () => _send(list),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}