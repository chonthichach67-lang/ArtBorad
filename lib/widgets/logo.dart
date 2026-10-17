import 'package:flutter/material.dart';

import '../core/theme.dart';

class Logo extends StatelessWidget {
  final double size;
  const Logo(this.size, {super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * .28),
              color: acc,
              border: Border.all(color: ink, width: 2.2),
              boxShadow: const [BoxShadow(color: shd, offset: Offset(2, 2))],
            ),
            child: Center(child: Icon(Icons.casino_rounded, color: Colors.white, size: size * .56)),
          ),
        ),
      );
}
