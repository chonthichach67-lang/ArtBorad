import 'package:testtt/models/app_user.dart';
import 'package:testtt/models/board_game.dart';

class Booking {
  int id = 0;
  String status = 'จองแล้ว';
  final AppUser u;
  final BoardGame g;
  final int ppl, start, hours, table, price, used;
  final bool full;
  final DateTime date;
  Booking({required this.u, required this.g, required this.ppl, required this.full, required this.date, required this.start, required this.hours, required this.table, required this.price, required this.used});
  int get earn => price ~/ 35;
}
