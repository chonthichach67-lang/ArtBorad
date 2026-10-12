import 'package:flutter/material.dart';
import 'package:testtt/models/app_user.dart';
import 'package:testtt/state/app_state.dart';
import 'package:testtt/screens/admin/admin_home.dart';
import 'package:testtt/screens/customer/home_page.dart';

/// เข้าสู่ระบบแล้วไปหน้าหลักตามบทบาท (แอดมิน / ลูกค้า)
void enter(BuildContext c, AppUser u) {
  AppState.i.me = u;
  Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_) => u.admin ? const AdminHome() : const Home()), (r) => false);
}
