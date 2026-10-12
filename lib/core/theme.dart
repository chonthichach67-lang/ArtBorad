import 'package:flutter/material.dart';

const bg = Color(0xFF05070D), cardC = Color(0xFF0D1220), acc = Color(0xFF00E5FF), acc2 = Color(0xFF7C4DFF);
const glowS = [Shadow(color: acc, blurRadius: 16)];
const mono = TextStyle(fontFamily: 'monospace', letterSpacing: 2);

ThemeData buildTheme() => ThemeData(
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6)), borderSide: BorderSide(color: acc, width: 1.5))));
