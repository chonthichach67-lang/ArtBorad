import 'package:flutter/material.dart';
import 'package:testtt/models/board_game.dart';
import 'package:testtt/widgets/neon.dart';

/// ที่ไว้ใส่รูปบอร์ดเกม
class GameImg extends StatelessWidget {
  final BoardGame g;
  final double size;
  const GameImg(this.g, {super.key, this.size = 78});
  @override
  Widget build(BuildContext context) {
    final ph = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
        child: Icon(Icons.image_outlined, color: Colors.white30, size: size * .4));
    if (g.img.isEmpty) return ph;
    return ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(g.img, width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) => ph));
  }
}

class GameCard extends StatelessWidget {
  final BoardGame g;
  final VoidCallback? onTap;
  final Widget? trailing;
  const GameCard(this.g, {super.key, this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: card(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GameImg(g),
        const SizedBox(width: 12),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(g.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), if (trailing != null) trailing!]),
          const SizedBox(height: 6),
          Text(g.desc, style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 6, children: [chip(Icons.group, '${g.min}-${g.max} คน'), chip(Icons.speed, g.diff), chip(Icons.timer, '${g.mins} นาที')]),
        ])),
      ])));
}
