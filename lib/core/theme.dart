import 'package:flutter/material.dart';

// ═════════════════════════════════════════════════════════════
//  ARTBOARD · Design System  (Neo-Pop Dark)
//  ธีม: พื้นหลังม่วงเข้มยามค่ำ + ขอบสว่างหนา + เงาดำแข็ง (hard shadow)
//  สีหลักแดง / ฟ้า / เหลืองทอง   แก้สีทั้งแอปได้ที่ชุดค่าคงที่นี้ชุดเดียว
// ═════════════════════════════════════════════════════════════
const ink = Color(0xFFE8E1F5); // สีเส้นขอบ (สว่าง)
const dk = Color(0xFF15121C); // ตัวอักษร/ไอคอนบนพื้นสีสด (เหลือง ฟ้า ขาว)
const fg = Color(0xFFF5F0FF); // ตัวอักษรหลัก
const shd = Color(0xFF000000); // เงาแข็ง
const bg = Color(0xFF16131D); // พื้นหลัง
const bg2 = Color(0xFF1B1725); // พื้นช่องกรอกข้อมูล
const cardC = Color(0xFF221D2E); // พื้นการ์ด
const lineC = ink;
const sand = Color(0xFF332C44); // พื้นรอง (อวาตาร์/ปุ่มปิด)
const offC = Color(0xFF3A3448); // โต๊ะไม่ว่าง
const acc = Color(0xFFFF4D6A); // แดง (สีหลัก / โต๊ะที่เลือก)
const acc2 = Color(0xFF6DB3F2); // ฟ้า (โต๊ะว่าง)
const gold = Color(0xFFFFD23F); // เหลือง (ปุ่ม / ตัวเลือกที่เลือก)
const goldDk = Color(0xFFFFC93C); // เหลืองสำหรับตัวอักษรบนพื้นมืด
const violet = Color(0xFFA796FF);
const okC = Color(0xFF3DDBA0);
const badC = Color(0xFFFF6B7F);
const txt2 = Color(0xFFB8AFCB);
const txt3 = Color(0xFF8A819E);
const onAcc = dk;
const glowS = [Shadow(color: acc, offset: Offset(3, 3))];
const mono = TextStyle(letterSpacing: 1);

/// ใส่ความโปร่งใสให้สี
Color al(Color c, double o) => c.withAlpha((o * 255).round().clamp(0, 255));

final dlgShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: ink, width: 2.5));

Color diffColor(String d) => d == 'ง่าย' ? okC : (d == 'ยาก' ? badC : goldDk);

/// ธีมหลักของแอป (ย้ายมาจาก ArtboardApp)
ThemeData buildAppTheme() {
  RoundedRectangleBorder r(double v) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(v));
  OutlineInputBorder ib(Color c, [double w = 2]) => OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamilyFallback: const ['Kanit', 'Prompt', 'Noto Sans Thai', 'Sarabun'],
    colorScheme: const ColorScheme.dark(
      primary: acc,
      onPrimary: Colors.white,
      secondary: acc2,
      onSecondary: dk,
      surface: cardC,
      onSurface: fg,
      secondaryContainer: gold,
      onSecondaryContainer: dk,
      outline: ink,
      error: badC,
    ),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: fg, displayColor: fg),
    scaffoldBackgroundColor: Colors.transparent,
    dividerTheme: DividerThemeData(color: al(ink, .3), thickness: 1.5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: fg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: .5, color: fg),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: dk,
        disabledBackgroundColor: sand,
        disabledForegroundColor: txt3,
        minimumSize: const Size(0, 48),
        side: const BorderSide(color: ink, width: 2.5),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        shape: r(14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46), foregroundColor: fg, side: const BorderSide(color: ink, width: 2), shape: r(14)),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: acc, textStyle: const TextStyle(fontWeight: FontWeight.w800))),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        side: const BorderSide(color: ink, width: 2),
        foregroundColor: fg,
        backgroundColor: cardC,
        selectedBackgroundColor: gold,
        selectedForegroundColor: dk,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF3A3350),
      contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: ink, width: 1.5)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bg2,
      labelStyle: const TextStyle(color: txt2),
      hintStyle: const TextStyle(color: txt3),
      border: ib(lineC),
      enabledBorder: ib(lineC),
      focusedBorder: ib(acc, 2.4),
    ),
  );
}
