import 'package:flutter/material.dart';

import '../models/debt.dart';
import 'debt_chart.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddPayment;

  const DebtCard({
    super.key,
    required this.debt,
    required this.onEdit,
    required this.onDelete,
    required this.onAddPayment,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (debt.progress * 100).clamp(0, 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xff1E293B),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  debt.personName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: onEdit,
                    child: const Text("Editar"),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    child: const Text("Eliminar"),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          DebtChart(
            paid: debt.paidAmount,
            pending: debt.pendingAmount,
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _item(
                "Total",
                "\$${debt.totalAmount.toStringAsFixed(0)}",
              ),
              _item(
                "Pagado",
                "\$${debt.paidAmount.toStringAsFixed(0)}",
              ),
              _item(
                "Debe",
                "\$${debt.pendingAmount.toStringAsFixed(0)}",
              ),
            ],
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(
            value: debt.progress.clamp(0, 1),
            minHeight: 10,
            borderRadius:
                BorderRadius.circular(100),
          ),

          const SizedBox(height: 10),

          Text(
            "${percent.toStringAsFixed(1)}% liquidado",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddPayment,
              icon: const Icon(Icons.payments),
              label: const Text(
                "Registrar Pago",
              ),
            ),
          ),

          if (debt.payments.isNotEmpty) ...[
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Historial",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...debt.payments.reversed.map(
              (payment) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading:
                    const Icon(Icons.receipt_long),
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
          ]
        ],
      ),
    );
  }

  Widget _item(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}