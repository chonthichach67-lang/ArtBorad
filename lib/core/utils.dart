import 'package:flutter/material.dart';

bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
String fmtD(DateTime d) => '${d.day}/${d.month}/${d.year}';
String fmtT(int s, int h) => '${s.toString().padLeft(2, '0')}:00-${(s + h).toString().padLeft(2, '0')}:00';

void snack(BuildContext c, String t) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(t)));
