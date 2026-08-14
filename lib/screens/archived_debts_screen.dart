import 'package:flutter/material.dart';

import '../models/debt.dart';
import '../widgets/debt_card.dart';

class ArchivedDebtsScreen
    extends StatelessWidget {

  final List<Debt> debts;

  const ArchivedDebtsScreen({
    super.key,
    required this.debts,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cuentas Pagadas",
        ),
      ),
      body: ListView.builder(
        padding:
            const EdgeInsets.all(16),
        itemCount: debts.length,
        itemBuilder: (_, index) {

          final debt =
              debts[index];

          return DebtCard(
            debt: debt,
            onEdit: () {},
            onDelete: () {},
            onAddPayment: () {},
            onViewDetail: () {}, 
            isArchived: true,
          );
        },
      ),
    );
  }
}