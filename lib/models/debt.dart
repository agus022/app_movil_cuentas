import 'package:hive/hive.dart';
import 'payment.dart';

part 'debt.g.dart';

@HiveType(typeId: 1)
class Debt extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String personName;

  @HiveField(2)
  double totalAmount;

  @HiveField(3)
  List<Payment> payments;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isArchived;

  @HiveField(6)
  int reminderDays;

  Debt({
    required this.id,
    required this.personName,
    required this.totalAmount,
    required this.payments,
    required this.createdAt,
    this.isArchived = false,
    this.reminderDays = 0,
  });

  double get paidAmount => payments.fold(
        0,
        (sum, payment) => sum + payment.amount,
      );

  double get pendingAmount => totalAmount - paidAmount;

  double get progress => paidAmount / totalAmount;
  DateTime get referenceDate {
    if (payments.isEmpty) {
      return createdAt;
    }

    payments.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return payments.first.date;
  }

  DateTime get nextReminderDate {
    return referenceDate.add(
      Duration(days: reminderDays),
    );
  }

  int get daysUntilReminder {
    return nextReminderDate.difference(DateTime.now()).inDays;
  }
}
