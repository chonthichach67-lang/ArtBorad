import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/game.dart';
import 'ui_helpers.dart';

class GameImg extends StatelessWidget {
  final Game g;
  final double size;
  const GameImg(this.g, {super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final c = diffColor(g.diff);
    final inner = Container(color: sand, child: Center(child: Icon(Icons.extension_rounded, color: c, size: size * .46)));
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: ink, width: 2.2)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.5),
        child: g.img.isEmpty
            ? inner
            : Image.asset(g.img, width: size, height: size, fit: BoxFit.cover, errorBuilder: (_, __, ___) => inner),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Game g;
  final VoidCallback? onTap;
  final Widget? trailing;
  const GameCard(this.g, {super.key, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) => card(
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GameImg(g),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(g.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, height: 1.25))),
                if (trailing != null) trailing!,
              ]),
              const SizedBox(height: 5),
              Text(g.desc, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(color: txt2, fontSize: 13, height: 1.35)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 6, children: [
                chip(Icons.group_rounded, '${g.min}-${g.max} คน'),
                chip(Icons.bolt_rounded, g.diff, diffColor(g.diff)),
                chip(Icons.timer_rounded, '${g.mins} นาที', violet),
              ]),
            ]),
          ),
        ]),
        onTap: onTap,
      );
}
