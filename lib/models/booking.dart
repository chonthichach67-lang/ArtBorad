import 'game.dart';
import 'user.dart';

class B {
  int id = 0;
  String status = 'จองแล้ว';
  final U u;
  final Game g;
  final int ppl, start, hours, table, price, used;
  final bool full;
  final DateTime date;

  B({
    required this.u,
    required this.g,
    required this.ppl,
    required this.full,
    required this.date,
    required this.start,
    required this.hours,
    required this.table,
    required this.price,
    required this.used,
  });

  int get earn => price ~/ 35;
}
