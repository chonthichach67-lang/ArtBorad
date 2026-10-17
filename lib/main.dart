import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'core/theme.dart';
import 'screens/auth/login.dart';
import 'widgets/tech_bg.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await S.i.init();
  runApp(const ArtboardApp());
}

class ArtboardApp extends StatelessWidget {
  const ArtboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ARTBOARD',
      debugShowCheckedModeBanner: false,
      // จำกัดความกว้างเนื้อหาบนจอใหญ่ (แท็บเล็ต/เว็บ) พื้นหลังยังเต็มจอ
      builder: (c, child) => TechBg(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(color: al(ink, .15), width: 1.5),
                ),
              ),
              child: child!,
            ),
          ),
        ),
      ),
      theme: buildAppTheme(),
      home: const Login(),
    );
  }
}
