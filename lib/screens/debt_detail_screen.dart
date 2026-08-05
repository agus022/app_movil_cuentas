import 'package:flutter/material.dart';

import '../models/debt.dart';
import '../widgets/debt_chart.dart';

class DebtDetailScreen extends StatelessWidget {

  final Debt debt;
  final VoidCallback onAddPayment;

  const DebtDetailScreen({
    super.key,
    required this.debt,
    required this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {

    final percent =
        (debt.progress * 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          debt.personName,
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            DebtChart(
              paid: debt.paidAmount,
              pending:
                  debt.pendingAmount,
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [

                _item(
                  "Total",
                  debt.totalAmount,
                ),

                _item(
                  "Pagado",
                  debt.paidAmount,
                ),

                _item(
                  "Debe",
                  debt.pendingAmount,
                ),
              ],
            ),

            const SizedBox(height: 25),

            LinearProgressIndicator(
              value:
                  debt.progress.clamp(
                0,
                1,
              ),
              minHeight: 12,
              borderRadius:
                  BorderRadius.circular(
                100,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "${percent.toStringAsFixed(1)}% liquidado",
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child:
                  ElevatedButton.icon(
                onPressed:
                    onAddPayment,
                icon: const Icon(
                  Icons.payments,
                ),
                label: const Text(
                  "Registrar Pago",
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Historial",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            ...debt.payments.reversed.map(
              (payment) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.receipt_long,
                  ),
                  title: Text(
                    "\$${payment.amount.toStringAsFixed(0)}",
                  ),
                  subtitle: Text(
                    payment.date
                        .toString()
                        .split(" ")
                        .first,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      String title,
      double value,
      ) {
    return Column(
      children: [
        Text(title),
        Text(
          "\$${value.toStringAsFixed(0)}",
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}