import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';
import 'package:testtt/widgets/tech_bg.dart';
import 'package:testtt/screens/auth/login_page.dart';

void main() => runApp(const ArtboardApp());

class ArtboardApp extends StatelessWidget {
  const ArtboardApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ARTBOARD',
        debugShowCheckedModeBanner: false,
        builder: (c, child) => TechBg(child: child!),
        theme: buildTheme(),
        home: const Login(),
      );
}
