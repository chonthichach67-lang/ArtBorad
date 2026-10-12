import 'package:flutter/material.dart';
import 'package:testtt/core/utils.dart';
import 'package:testtt/models/app_user.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/form_fields.dart';
import 'package:testtt/screens/auth/auth_helpers.dart';

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
                    if (AppState.i.users.any((x) => x.name == name)) return snack(context, 'ชื่อนี้ถูกใช้แล้ว');
                    final u = AppUser(name, p.text, phone: ph.text.trim(), email: em.text.trim());
                    AppState.i.users.add(u);
                    enter(context, u);
                  },
                  child: const Text('สมัครสมาชิก'))),
        ]));
  }
}
