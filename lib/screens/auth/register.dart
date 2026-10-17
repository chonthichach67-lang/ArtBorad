import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../models/user.dart';
import '../../state/app_state.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/neon.dart';
import '../../widgets/ui_helpers.dart';
import 'auth_actions.dart';

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
