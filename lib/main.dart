import 'package:flutter/material.dart';

void main() => runApp(const ArtboardApp());

const bg = Color(0xFF05070D), cardC = Color(0xFF0D1220), acc = Color(0xFF00E5FF), acc2 = Color(0xFF7C4DFF);
const glowS = [Shadow(color: acc, blurRadius: 16)];
const mono = TextStyle(fontFamily: 'monospace', letterSpacing: 2);

/// กรอบการ์ดสไตล์ HUD: ไล่เฉดน้ำเงินเข้ม + ขอบนีออน + เรืองแสง
BoxDecoration neon({Color c = acc, double w = 1, double a = .25}) => BoxDecoration(
    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F1A2E), Color(0xFF080C16)]),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: c.withOpacity(a), width: w),
    boxShadow: [BoxShadow(color: c.withOpacity(a * .35), blurRadius: 14)]);

/// พื้นหลังแอป: เรืองแสงมุมบน + เส้นกริดจางๆ
class TechBg extends StatelessWidget {
  final Widget child;
  const TechBg({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
        Container(decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment(.9, -1), radius: 1.4, colors: [Color(0xFF0A2236), bg, Color(0xFF020309)], stops: [0, .55, 1]))),
        CustomPaint(painter: _Grid()),
        child,
      ]);
}

class _Grid extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = const Color(0x1000E5FF)..strokeWidth = 1;
    for (double x = 0; x < s.width; x += 32) c.drawLine(Offset(x, 0), Offset(x, s.height), p);
    for (double y = 0; y < s.height; y += 32) c.drawLine(Offset(0, y), Offset(s.width, y), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

// ───────── Models ─────────
class Game {
  String name, desc, diff, img; // img = path รูปใน assets เช่น assets/games/codenames.png (ว่าง = แสดงกรอบเปล่า)
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
  B({required this.u, required this.g, required this.ppl, required this.full, required this.date, required this.start, required this.hours, required this.table, required this.price, required this.used});
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

// ───────── State (in-memory; swap for Firebase/REST later) ─────────
class S extends ChangeNotifier {
  static final i = S._();
  S._();
  final users = <U>[U('admin', 'admin', admin: true)];
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
}

// ───────── Helpers ─────────
Widget card(Widget c, {EdgeInsets m = const EdgeInsets.symmetric(horizontal: 16, vertical: 6)}) => Container(
    margin: m,
    padding: const EdgeInsets.all(14),
    decoration: neon(),
    child: c);

Widget tf(TextEditingController c, String l, {bool obscure = false, TextInputType? k}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(controller: c, obscureText: obscure, keyboardType: k, decoration: InputDecoration(labelText: l, border: const OutlineInputBorder())));

Widget chip(IconData i, String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: const Color(0x1400E5FF), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0x4400E5FF))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 14, color: acc), const SizedBox(width: 5), Text(t, style: const TextStyle(fontSize: 12))]));

void snack(BuildContext c, String t) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(t)));

/// โลโก้ร้าน ARTBOARD (assets/logo.png) — ถ้าหาไฟล์ไม่เจอจะแสดงกรอบเปล่าแทน
class Logo extends StatelessWidget {
  final double size;
  const Logo(this.size, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/logo.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(size * .18), border: Border.all(color: acc, width: 2), color: Colors.black),
              child: Center(child: Icon(Icons.add_photo_alternate_outlined, color: acc, size: size * .45)))));
}

/// ที่ไว้ใส่รูปบอร์ดเกม
class GameImg extends StatelessWidget {
  final Game g;
  final double size;
  const GameImg(this.g, {super.key, this.size = 78});
  @override
  Widget build(BuildContext context) {
    final ph = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
        child: Icon(Icons.image_outlined, color: Colors.white30, size: size * .4));
    if (g.img.isEmpty) return ph;
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(g.img, width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) => ph));
  }
}

class GameCard extends StatelessWidget {
  final Game g;
  final VoidCallback? onTap;
  final Widget? trailing;
  const GameCard(this.g, {super.key, this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: card(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GameImg(g),
        const SizedBox(width: 12),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(g.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), if (trailing != null) trailing!]),
          const SizedBox(height: 6),
          Text(g.desc, style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, children: [chip(Icons.group, '${g.min}-${g.max} คน'), chip(Icons.speed, g.diff), chip(Icons.timer, '${g.mins} นาที')]),
        ])),
      ])));
}

class ArtboardApp extends StatelessWidget {
  const ArtboardApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'ARTBOARD',
      debugShowCheckedModeBanner: false,
      builder: (c, child) => TechBg(child: child!),
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.transparent,
          colorScheme: const ColorScheme.dark(primary: acc, secondary: acc2, surface: cardC),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, scrolledUnderElevation: 0, titleTextStyle: TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2, color: Colors.white)),
          navigationBarTheme: const NavigationBarThemeData(backgroundColor: Color(0xE6070B14), indicatorColor: Color(0x3300E5FF)),
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  backgroundColor: acc,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(14), bottomRight: Radius.circular(14))))),
          inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFF0A1020),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide(color: Color(0x5500E5FF))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide(color: Color(0x5500E5FF))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide(color: acc, width: 1.5)))),
      home: const Login());
}

void enter(BuildContext c, U u) {
  S.i.me = u;
  Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => u.admin ? const AdminHome() : const Home()), (r) => false);
}

// ───────── Auth ─────────
class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final n = TextEditingController(), p = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(children: [
                const Logo(170),
                const SizedBox(height: 18),
                const Text('ARTBOARD', style: TextStyle(fontFamily: 'monospace', fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 8, shadows: glowS)),
                const Text('BOARD GAME CAFE', style: TextStyle(fontFamily: 'monospace', color: acc, letterSpacing: 3, fontSize: 12)),
                const SizedBox(height: 32),
                tf(n, 'ชื่อผู้ใช้'),
                tf(p, 'รหัสผ่าน', obscure: true),
                SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                        onPressed: () {
                          final u = S.i.users.where((x) => x.name == n.text.trim() && x.pass == p.text).firstOrNull;
                          u == null ? snack(context, 'ชื่อหรือรหัสผ่านไม่ถูกต้อง') : enter(context, u);
                        },
                        child: const Text('เข้าสู่ระบบ'))),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())), child: const Text('ยังไม่มีบัญชี? ลงทะเบียน')),
                const Text('แอดมินทดลอง: admin / admin', style: TextStyle(color: Colors.white30, fontSize: 11)),
              ]))));
}

class Register extends StatelessWidget {
  const Register({super.key});
  @override
  Widget build(BuildContext context) {
    final n = TextEditingController(), ph = TextEditingController(), em = TextEditingController(), p = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: const Text('ลงทะเบียน')),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          tf(n, 'ชื่อ'),
          tf(ph, 'เบอร์โทร', k: TextInputType.phone),
          tf(em, 'อีเมล', k: TextInputType.emailAddress),
          tf(p, 'รหัสผ่าน', obscure: true),
          SizedBox(
              height: 48,
              child: FilledButton(
                  onPressed: () {
                    final name = n.text.trim();
                    if (name.isEmpty || ph.text.trim().length < 9 || !em.text.contains('@') || p.text.length < 4) return snack(context, 'กรอกข้อมูลให้ครบ (เบอร์ ≥ 9 หลัก, อีเมลถูกต้อง, รหัส ≥ 4 ตัว)');
                    if (S.i.users.any((x) => x.name == name)) return snack(context, 'ชื่อนี้ถูกใช้แล้ว');
                    final u = U(name, p.text, phone: ph.text.trim(), email: em.text.trim());
                    S.i.users.add(u);
                    enter(context, u);
                  },
                  child: const Text('สมัครสมาชิก'))),
        ]));
  }
}

// ───────── Customer ─────────
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
      animation: S.i,
      builder: (_, __) {
        final u = S.i.me!;
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

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(children: [for (final g in S.i.games) GameCard(g)]);
}

class BookTab extends StatelessWidget {
  const BookTab({super.key});
  @override
  Widget build(BuildContext context) => ListView(children: [
        const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text('เลือกบอร์ดเกมที่อยากเล่น', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        for (final g in S.i.games) GameCard(g, trailing: const Icon(Icons.chevron_right, color: acc), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(g)))),
      ]);
}

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

  Widget stepper(int v, int lo, int hi, ValueChanged<int> f, String unit) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: v > lo ? () => f(v - 1) : null, icon: const Icon(Icons.remove_circle_outline)),
        Text('$v $unit', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(onPressed: v < hi ? () => f(v + 1) : null, icon: const Icon(Icons.add_circle_outline, color: acc)),
      ]);

  @override
  Widget build(BuildContext context) {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final freeCount = [1, 2, 3].where((t) => S.i.free(t, date, s, h, widget.edit)).length;
    return Scaffold(
        appBar: AppBar(title: Text(widget.edit == null ? 'จองโต๊ะ' : 'แก้ไขการจอง #${widget.edit!.id}')),
        body: ListView(padding: const EdgeInsets.only(bottom: 30), children: [
          GameCard(widget.g),
          card(Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('จำนวนคน'), stepper(ppl, 1, 12, (v) { ppl = v; fix(); }, 'คน')]),
            SegmentedButton<bool>(
                segments: const [ButtonSegment(value: false, label: Text('รายชั่วโมง')), ButtonSegment(value: true, label: Text('เหมาทั้งวัน'))],
                selected: {full},
                onSelectionChanged: (v) { full = v.first; fix(); }),
          ])),
          card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('รายละเอียดราคา', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('• รายชั่วโมง  35 บาท / คน / ชั่วโมง', style: TextStyle(color: Colors.white70)),
            const Text('• เหมาวัน  135 บาท / คน', style: TextStyle(color: Colors.white70)),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('ราคาที่ต้องชำระ'), Text('${base - disc} บาท', style: const TextStyle(color: acc, fontSize: 20, fontWeight: FontWeight.w900))]),
          ])),
          card(Column(children: [
            ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month, color: acc),
                title: const Text('วันที่'),
                trailing: Text(fmtD(date)),
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: date, firstDate: date.isBefore(today) ? date : today, lastDate: today.add(const Duration(days: 60)));
                  if (d != null) { date = d; fix(); }
                }),
            if (!full) ...[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Row(children: [Icon(Icons.schedule, color: acc), SizedBox(width: 12), Text('เวลาเริ่ม')]),
                DropdownButton<int>(value: start, items: [for (var t = 10; t < 22; t++) DropdownMenuItem(value: t, child: Text('${t.toString().padLeft(2, '0')}:00'))], onChanged: (v) { start = v!; if (start + hours > 22) hours = 22 - start; fix(); }),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('จำนวนชั่วโมง'), stepper(hours, 1, 22 - start, (v) { hours = v; fix(); }, 'ชม.')]),
            ] else
              const Text('เหมาวัน: 10:00-22:00', style: TextStyle(color: Colors.white60)),
          ])),
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: Text('โต๊ะที่ว่าง $freeCount / 3 โต๊ะ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          for (final t in [1, 2, 3])
            Builder(builder: (_) {
              final ok = S.i.free(t, date, s, h, widget.edit);
              return Opacity(
                  opacity: ok ? 1 : .4,
                  child: InkWell(
                      onTap: ok ? () => setState(() => table = t) : null,
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          padding: const EdgeInsets.all(14),
                          decoration: neon(w: table == t ? 2 : 1, a: table == t ? .9 : .18),
                          child: Row(children: [Icon(Icons.table_restaurant, color: ok ? Colors.greenAccent : Colors.redAccent), const SizedBox(width: 12), Text('โต๊ะ $t'), const Spacer(), Text(ok ? 'ว่าง' : 'ไม่ว่าง')]))));
            }),
          if (avail >= 15) card(SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('ใช้ 15 แต้ม แลกฟรี 1 ชั่วโมง (-35 บาท)'), subtitle: Text('แต้มคงเหลือ $avail'), value: redeem, onChanged: (v) { redeem = v; fix(); })),
          Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 50,
                  child: FilledButton(
                      onPressed: table == null
                          ? null
                          : () {
                              final b = B(u: S.i.me!, g: widget.g, ppl: ppl, full: full, date: date, start: s, hours: h, table: table!, price: base - disc, used: redeem ? 1 : 0);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => Summary(b, widget.edit)));
                            },
                      child: Text(table == null ? 'เลือกโต๊ะก่อนยืนยัน' : 'ยืนยัน → สรุปรายละเอียด')))),
        ]));
  }
}

class Summary extends StatelessWidget {
  final B b;
  final B? old;
  const Summary(this.b, this.old, {super.key});
  Widget row(String a, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(a, style: const TextStyle(color: Colors.white60)), Flexible(child: Text(v, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600)))]));
  @override
  Widget build(BuildContext context) {
    final o = old;
    final after = b.u.pts + (o != null && o.status != 'ยกเลิก' ? o.used * 15 - o.earn : 0) + b.earn - b.used * 15;
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปการจอง')),
      body: ListView(children: [
        card(Column(children: [
          row('บอร์ดเกม', b.g.name),
          row('จำนวนผู้เล่น', '${b.ppl} คน'),
          row('วันที่', fmtD(b.date)),
          row('เวลา', fmtT(b.start, b.hours)),
          row('จำนวนชั่วโมง', b.full ? 'เหมาวัน' : '${b.hours} ชม.'),
          row('โต๊ะ', 'โต๊ะ ${b.table}'),
          if (b.used > 0) row('ส่วนลดแลกแต้ม', '-35 บาท'),
          const Divider(),
          row('ราคาที่ต้องชำระ', '${b.price} บาท'),
          row('แต้มที่จะได้รับ', '+${b.earn} แต้ม'),
        ])),
        card(Row(children: [
          const Icon(Icons.stars, color: acc, size: 40),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('คุณจะได้รับ +${b.earn} แต้ม', style: const TextStyle(color: acc, fontSize: 20, fontWeight: FontWeight.w900)),
            Text('(${b.price} บาท ÷ 35 = ${b.earn} แต้ม)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            if (b.used > 0) const Text('ใช้แต้มแลกฟรี 1 ชม.: -15 แต้ม', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text('แต้มสะสมหลังจองเสร็จ: $after แต้ม', style: const TextStyle(fontSize: 13)),
          ])),
        ])),
        Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
                height: 50,
                child: FilledButton(
                    onPressed: () {
                      final m = ScaffoldMessenger.of(context);
                      S.i.save(b, old);
                      Navigator.popUntil(context, (r) => r.isFirst);
                      m.showSnackBar(SnackBar(content: Text('บันทึกการจองแล้ว ได้รับ ${b.earn} แต้ม')));
                    },
                    child: const Text('ยืนยันการจอง')))),
      ]));
  }
}

class PointsTab extends StatelessWidget {
  const PointsTab({super.key});
  @override
  Widget build(BuildContext context) {
    final p = S.i.me!.pts;
    return ListView(children: [
      card(Column(children: [
        const Text('แต้มสะสมของคุณ', style: TextStyle(color: Colors.white60)),
        Text('$p', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: acc, shadows: glowS)),
        LinearProgressIndicator(value: (p % 15) / 15, minHeight: 8, borderRadius: BorderRadius.circular(8)),
        const SizedBox(height: 8),
        Text(p >= 15 ? 'แลกเล่นฟรี 1 ชั่วโมงได้แล้ว! (ตอนจอง)' : 'อีก ${15 - p} แต้ม แลกฟรี 1 ชั่วโมง'),
      ])),
      card(const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('วิธีสะสมแต้ม', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('• ทุก 35 บาท ได้ 1 แต้ม (คำนวณอัตโนมัติหลังจอง)'),
        Text('• ลงสตอรี่แท็กร้าน ได้เพิ่ม 1 แต้ม (แจ้งแอดมิน)'),
        Text('• สะสมครบ 15 แต้ม แลกฟรี 1 ชั่วโมง'),
      ])),
    ]);
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});
  @override
  Widget build(BuildContext context) {
    final l = S.i.bookings.where((b) => b.u == S.i.me).toList().reversed.toList();
    if (l.isEmpty) return const Center(child: Text('ยังไม่มีประวัติการจอง'));
    return ListView(children: [
      for (final b in l)
        card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text('#${b.id} ${b.g.name}', style: const TextStyle(fontWeight: FontWeight.bold))), Text(b.status, style: TextStyle(color: b.status == 'ยกเลิก' ? Colors.redAccent : Colors.greenAccent))]),
          const SizedBox(height: 6),
          Text('${fmtD(b.date)}  ${fmtT(b.start, b.hours)}  • โต๊ะ ${b.table} • ${b.ppl} คน'),
          Text('${b.price} บาท • +${b.earn} แต้ม', style: const TextStyle(color: acc)),
          if (b.status != 'ยกเลิก')
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookPage(b.g, edit: b))), child: const Text('แก้ไข')),
              TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (d) => AlertDialog(title: const Text('ยกเลิกการจอง?'), actions: [
                            TextButton(onPressed: () => Navigator.pop(d), child: const Text('ไม่')),
                            FilledButton(onPressed: () { S.i.cancel(b); Navigator.pop(d); }, child: const Text('ยกเลิกการจอง'))
                          ])),
                  child: const Text('ยกเลิก', style: TextStyle(color: Colors.redAccent))),
            ]),
        ])),
    ]);
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  void edit(BuildContext c, String title, String init, bool obscure, void Function(String) ok) {
    final t = TextEditingController(text: init);
    showDialog(
        context: c,
        builder: (d) => AlertDialog(title: Text(title), content: tf(t, title, obscure: obscure), actions: [
              TextButton(onPressed: () => Navigator.pop(d), child: const Text('ยกเลิก')),
              FilledButton(onPressed: () { if (t.text.trim().isNotEmpty) { ok(t.text.trim()); S.i.ping(); Navigator.pop(d); } }, child: const Text('บันทึก'))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    final u = S.i.me!;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Center(child: CircleAvatar(radius: 52, backgroundColor: u.photo ? acc : Colors.white12, child: Icon(Icons.person, size: 56, color: u.photo ? Colors.black : Colors.white38))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton.icon(onPressed: () { u.photo = true; S.i.ping(); }, icon: const Icon(Icons.add_a_photo), label: const Text('เพิ่มรูป')),
        TextButton.icon(onPressed: () { u.photo = false; S.i.ping(); }, icon: const Icon(Icons.delete_outline), label: const Text('ลบรูป')),
      ]),
      Center(child: Text(u.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      Center(child: Text('${u.phone}  •  ${u.email}', style: const TextStyle(color: Colors.white54))),
      const SizedBox(height: 16),
      card(Column(children: [
        ListTile(leading: const Icon(Icons.badge_outlined), title: const Text('แก้ไขชื่อ'), onTap: () => edit(context, 'ชื่อใหม่', u.name, false, (v) => u.name = v)),
        ListTile(leading: const Icon(Icons.lock_outline), title: const Text('เปลี่ยนรหัสผ่าน'), onTap: () => edit(context, 'รหัสผ่านใหม่', '', true, (v) => u.pass = v)),
        ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text('ลบบัญชี', style: TextStyle(color: Colors.redAccent)),
            onTap: () => showDialog(
                context: context,
                builder: (d) => AlertDialog(title: const Text('ลบบัญชีถาวร?'), content: const Text('ประวัติการจองและแต้มทั้งหมดจะหายไป'), actions: [
                      TextButton(onPressed: () => Navigator.pop(d), child: const Text('ยกเลิก')),
                      FilledButton(
                          onPressed: () {
                            S.i.bookings.removeWhere((b) => b.u == u);
                            S.i.chats.remove(u);
                            S.i.users.remove(u);
                            S.i.me = null;
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (r) => false);
                          },
                          child: const Text('ลบบัญชี'))
                    ]))),
        ListTile(leading: const Icon(Icons.logout), title: const Text('ออกจากระบบ'), onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (r) => false)),
      ])),
    ]);
  }
}

// ───────── Chat (customer ↔ admin) ─────────
class ChatPage extends StatelessWidget {
  final U u;
  final bool admin;
  const ChatPage(this.u, this.admin, {super.key});
  @override
  Widget build(BuildContext context) {
    final t = TextEditingController();
    void send() {
      if (t.text.trim().isEmpty) return;
      S.i.chats.putIfAbsent(u, () => []).add(M(admin, t.text.trim()));
      if (!admin) S.i.notes.add('💬 ${u.name}: ${t.text.trim()}');
      t.clear();
      S.i.ping();
    }

    return Scaffold(
        appBar: AppBar(title: Text(admin ? 'แชทกับ ${u.name}' : 'ติดต่อแอดมิน')),
        body: Column(children: [
          Expanded(
              child: AnimatedBuilder(
                  animation: S.i,
                  builder: (_, __) {
                    final l = S.i.chats[u] ?? [];
                    return ListView(padding: const EdgeInsets.all(12), children: [
                      for (final m in l)
                        Align(
                            alignment: m.admin == admin ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: m.admin == admin ? acc : Colors.white12, borderRadius: BorderRadius.circular(16)), child: Text(m.t, style: TextStyle(color: m.admin == admin ? Colors.black : Colors.white)))),
                    ]);
                  })),
          SafeArea(child: Padding(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: t, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'พิมพ์ข้อความ...', border: OutlineInputBorder()))), IconButton(onPressed: send, icon: const Icon(Icons.send, color: acc))]))),
        ]));
  }
}

// ───────── Admin back office ─────────
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const TablesAdmin(), const QueueAdmin(), const GamesAdmin(), const PointsAdmin(), const ChatsAdmin()];
    return AnimatedBuilder(
        animation: S.i,
        builder: (_, __) {
          final n = S.i.notes.length;
          return Scaffold(
              appBar: AppBar(title: const Row(children: [Logo(36), SizedBox(width: 10), Text('ARTBOARD ADMIN', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2))]), actions: [
                IconButton(
                    icon: Badge(label: Text('$n'), isLabelVisible: n > 0, child: const Icon(Icons.notifications_outlined)),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (d) => AlertDialog(title: const Text('การแจ้งเตือน'), content: SizedBox(width: double.maxFinite, child: n == 0 ? const Text('ไม่มีการแจ้งเตือนใหม่') : ListView(shrinkWrap: true, children: [for (final x in S.i.notes.reversed) ListTile(dense: true, title: Text(x))])), actions: [
                              TextButton(onPressed: () { S.i.notes.clear(); S.i.ping(); Navigator.pop(d); }, child: const Text('ล้างทั้งหมด')),
                              TextButton(onPressed: () => Navigator.pop(d), child: const Text('ปิด'))
                            ]))),
                IconButton(icon: const Icon(Icons.logout), onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (r) => false)),
              ]),
              body: pages[i],
              bottomNavigationBar: NavigationBar(selectedIndex: i, onDestinationSelected: (v) => setState(() => i = v), destinations: const [
                NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), label: 'โต๊ะ'),
                NavigationDestination(icon: Icon(Icons.list_alt), label: 'คิวจอง'),
                NavigationDestination(icon: Icon(Icons.casino_outlined), label: 'เกม'),
                NavigationDestination(icon: Icon(Icons.stars_outlined), label: 'แต้ม'),
                NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'แชท'),
              ]));
        });
  }
}

class TablesAdmin extends StatelessWidget {
  const TablesAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return ListView(padding: const EdgeInsets.all(8), children: [
      const Padding(padding: EdgeInsets.all(8), child: Text('แผนผังโต๊ะ (ตอนนี้) — แตะเพื่อปิด/เปิดโต๊ะ', style: TextStyle(color: Colors.white60))),
      GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, padding: const EdgeInsets.all(8), children: [
        for (final t in [1, 2, 3])
          Builder(builder: (_) {
            final closed = S.i.closed.contains(t);
            final busy = !closed && !S.i.free(t, now, now.hour, 1);
            final c = closed ? Colors.grey : busy ? Colors.redAccent : Colors.greenAccent;
            return InkWell(
                onTap: () { closed ? S.i.closed.remove(t) : S.i.closed.add(t); S.i.ping(); },
                child: Container(decoration: neon(c: c, w: 2, a: .8), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.table_restaurant, color: c, size: 36), Text('โต๊ะ $t', style: const TextStyle(fontWeight: FontWeight.bold)), Text(closed ? 'ปิด' : busy ? 'ไม่ว่าง' : 'ว่าง', style: TextStyle(color: c))])));
          })
      ]),
    ]);
  }
}

class QueueAdmin extends StatelessWidget {
  const QueueAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final l = [...S.i.bookings]..sort((a, b) => a.date.compareTo(b.date) != 0 ? a.date.compareTo(b.date) : a.start.compareTo(b.start));
    if (l.isEmpty) return const Center(child: Text('ยังไม่มีคิวจอง'));
    return ListView(children: [
      for (final b in l)
        card(Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('#${b.id} ${b.u.name}  (${b.u.phone})', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(b.g.name, style: const TextStyle(color: Colors.white60)),
            Text('${fmtD(b.date)} ${fmtT(b.start, b.hours)} • โต๊ะ ${b.table} • ${b.ppl} คน • ${b.price} บาท'),
          ])),
          b.status == 'ยกเลิก' ? const Text('ยกเลิก', style: TextStyle(color: Colors.redAccent)) : IconButton(icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent), onPressed: () => S.i.cancel(b)),
        ])),
    ]);
  }
}

class GamesAdmin extends StatelessWidget {
  const GamesAdmin({super.key});
  void form(BuildContext c, [Game? g]) {
    final n = TextEditingController(text: g?.name), d = TextEditingController(text: g?.desc), mn = TextEditingController(text: '${g?.min ?? 2}'), mx = TextEditingController(text: '${g?.max ?? 4}'), df = TextEditingController(text: g?.diff ?? 'ปานกลาง'), tm = TextEditingController(text: '${g?.mins ?? 30}'), im = TextEditingController(text: g?.img ?? '');
    showDialog(
        context: c,
        builder: (x) => AlertDialog(
                title: Text(g == null ? 'เพิ่มเกม' : 'แก้ไขเกม'),
                content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [tf(n, 'ชื่อเกม'), tf(d, 'รายละเอียดการเล่น'), tf(mn, 'ผู้เล่นขั้นต่ำ', k: TextInputType.number), tf(mx, 'ผู้เล่นสูงสุด', k: TextInputType.number), tf(df, 'ระดับความยาก'), tf(tm, 'ระยะเวลา (นาที)', k: TextInputType.number), tf(im, 'รูปเกม (เช่น assets/games/codenames.png)')])),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(x), child: const Text('ยกเลิก')),
                  FilledButton(
                      onPressed: () {
                        if (n.text.trim().isEmpty) return;
                        final a = int.tryParse(mn.text) ?? 2, b = int.tryParse(mx.text) ?? 4, m = int.tryParse(tm.text) ?? 30;
                        if (g == null) {
                          S.i.games.add(Game(n.text.trim(), d.text.trim(), a, b, df.text.trim(), m, im.text.trim()));
                        } else {
                          g..name = n.text.trim()..desc = d.text.trim()..min = a..max = b..diff = df.text.trim()..mins = m..img = im.text.trim();
                        }
                        S.i.ping();
                        Navigator.pop(x);
                      },
                      child: const Text('บันทึก'))
                ]));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(onPressed: () => form(context), child: const Icon(Icons.add)),
      body: ListView(padding: const EdgeInsets.only(bottom: 80), children: [
        for (final g in S.i.games)
          GameCard(g, trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => form(context, g)),
            IconButton(icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent), onPressed: () { S.i.games.remove(g); S.i.ping(); }),
          ])),
      ]));
}

class PointsAdmin extends StatelessWidget {
  const PointsAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final l = S.i.users.where((u) => !u.admin).toList();
    if (l.isEmpty) return const Center(child: Text('ยังไม่มีสมาชิก'));
    return ListView(children: [
      for (final u in l)
        card(Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)), Text('${u.pts} แต้ม', style: const TextStyle(color: acc, fontSize: 18))])),
          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: u.pts > 0 ? () { u.pts--; S.i.ping(); } : null),
          IconButton(icon: const Icon(Icons.add_circle_outline, color: acc), onPressed: () { u.pts++; S.i.ping(); }),
          TextButton(onPressed: () { u.pts++; S.i.ping(); }, child: const Text('สตอรี่ +1')),
        ])),
    ]);
  }
}

class ChatsAdmin extends StatelessWidget {
  const ChatsAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    final l = S.i.users.where((u) => !u.admin).toList();
    if (l.isEmpty) return const Center(child: Text('ยังไม่มีลูกค้า'));
    return ListView(children: [
      for (final u in l)
        ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(u.name),
            subtitle: Text((S.i.chats[u]?.isNotEmpty ?? false) ? S.i.chats[u]!.last.t : 'ยังไม่มีข้อความ', maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(u, true)))),
    ]);
  }
}