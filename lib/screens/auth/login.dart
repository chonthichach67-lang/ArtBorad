import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../state/app_state.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/logo.dart';
import '../../widgets/neon.dart';
import '../../widgets/ui_helpers.dart';
import 'auth_actions.dart';
import 'register.dart';

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
