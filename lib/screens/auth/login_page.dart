import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/form_fields.dart';
import 'package:testtt/widgets/logo.dart';
import 'package:testtt/screens/auth/auth_helpers.dart';
import 'package:testtt/screens/auth/register_page.dart';

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
                          final matches = AppState.i.users.where((x) => x.name == n.text.trim() && x.pass == p.text).toList();
                          final u = matches.isNotEmpty ? matches.first : null;
                          u == null ? snack(context, 'ชื่อหรือรหัสผ่านไม่ถูกต้อง') : enter(context, u);
                        },
                        child: const Text('เข้าสู่ระบบ'))),
                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Register())), child: const Text('ยังไม่มีบัญชี? ลงทะเบียน')),
                const Text('แอดมินทดลอง: admin / admin', style: TextStyle(color: Colors.white30, fontSize: 11)),
              ]))));
}
