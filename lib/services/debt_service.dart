import 'package:hive/hive.dart';
import '../models/debt.dart';

class DebtService {

  static final box =
      Hive.box<Debt>('debts');

  static List<Debt> getAll() {
    return box.values.toList();
  }

  static Future<void> add(
    Debt debt,
  ) async {
    await box.put(
      debt.id,
      debt,
    );
  }

  static Future<void> delete(
    String id,
  ) async {
    await box.delete(id);
  }

  static Future<void> update(
    Debt debt,
  ) async {
    await box.put(
      debt.id,
      debt,
    );
  }
}