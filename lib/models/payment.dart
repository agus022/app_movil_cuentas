import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 0)
class Payment extends HiveObject {

  @HiveField(0)
  double amount;

  @HiveField(1)
  DateTime date;

  Payment({
    required this.amount,
    required this.date,
  });
}