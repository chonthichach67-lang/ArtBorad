import 'package:flutter/material.dart';

import '../core/theme.dart';

Widget tf(TextEditingController c, String l, {bool obscure = false, TextInputType? k, IconData? icon}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: obscure,
        keyboardType: k,
        decoration: InputDecoration(labelText: l, prefixIcon: icon == null ? null : Icon(icon, size: 20, color: txt2)),
      ),
    );
