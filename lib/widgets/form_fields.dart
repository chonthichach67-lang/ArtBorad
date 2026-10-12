import 'package:flutter/material.dart';

Widget tf(TextEditingController c, String l, {bool obscure = false, TextInputType? k}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(controller: c, obscureText: obscure, keyboardType: k, decoration: InputDecoration(labelText: l, border: const OutlineInputBorder())));
