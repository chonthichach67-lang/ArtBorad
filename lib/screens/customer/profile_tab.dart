import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/widgets/form_fields.dart';
import 'package:testtt/widgets/neon.dart';
import 'package:testtt/screens/auth/login_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  void edit(BuildContext c, String title, String init, bool obscure, void Function(String) ok) {
    final t = TextEditingController(text: init);
    showDialog(
        context: c,
        builder: (d) => AlertDialog(title: Text(title), content: tf(t, title, obscure: obscure), actions: [
              TextButton(onPressed: () => Navigator.pop(d), child: const Text('ยกเลิก')),
              FilledButton(onPressed: () { if (t.text.trim().isNotEmpty) { ok(t.text.trim()); AppState.i.ping(); Navigator.pop(d); } }, child: const Text('บันทึก'))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    final u = AppState.i.me!;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Center(child: CircleAvatar(radius: 52, backgroundColor: u.photo ? acc : Colors.white12, child: Icon(Icons.person, size: 56, color: u.photo ? Colors.black : Colors.white38))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton.icon(onPressed: () { u.photo = true; AppState.i.ping(); }, icon: const Icon(Icons.add_a_photo), label: const Text('เพิ่มรูป')),
        TextButton.icon(onPressed: () { u.photo = false; AppState.i.ping(); }, icon: const Icon(Icons.delete_outline), label: const Text('ลบรูป')),
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
                            AppState.i.bookings.removeWhere((b) => b.u == u);
                            AppState.i.chats.remove(u);
                            AppState.i.users.remove(u);
                            AppState.i.me = null;
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (r) => false);
                          },
                          child: const Text('ลบบัญชี'))
                    ]))),
        ListTile(leading: const Icon(Icons.logout), title: const Text('ออกจากระบบ'), onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Login()), (r) => false)),
      ])),
    ]);
  }
}
