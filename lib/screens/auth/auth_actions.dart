import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../state/app_state.dart';
import '../admin/admin_home.dart';
import '../customer/home.dart';
import 'login.dart';

void enter(BuildContext c, U u) {
  S.i.me = u;
  Navigator.pushAndRemoveUntil(
    c,
    MaterialPageRoute(
      builder: (_) => u.admin ? const AdminHome() : const Home(),
    ),
    (r) => false,
  );
}

void logout(BuildContext c) {
  S.i.me = null;
  Navigator.pushAndRemoveUntil(
    c,
    MaterialPageRoute(builder: (_) => const Login()),
    (r) => false,
  );
}
