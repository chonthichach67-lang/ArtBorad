import 'package:flutter/material.dart';

import '../core/theme.dart';

/// แถบแต้มแบบเหรียญ (15 เหรียญ = แลกฟรี 1 ชม.)
class PipBar extends StatelessWidget {
  final int filled, total;
  final Color color;
  const PipBar(this.filled, {super.key, this.total = 15, this.color = gold});

  @override
  Widget build(BuildContext context) => Wrap(spacing: 5, runSpacing: 5, children: [
        for (var i = 0; i < total; i++)
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? color : al(ink, .08),
              border: Border.all(color: i < filled ? ink : al(ink, .3), width: 1.6),
            ),
          ),
      ]);
}
