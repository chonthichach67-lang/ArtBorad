import 'package:flutter/material.dart';
import 'package:testtt/core/theme.dart';

/// โลโก้ร้าน ARTBOARD (assets/images/logo.jpg)
class Logo extends StatelessWidget {
  final double size;
  const Logo(this.size, {super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/images/logo.jpg',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(size * .18), border: Border.all(color: acc, width: 2), color: Colors.black),
              child: Center(child: Icon(Icons.add_photo_alternate_outlined, color: acc, size: size * .45)))));
}
