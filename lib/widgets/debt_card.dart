import 'package:flutter/material.dart';

import '../models/debt.dart';
import 'debt_progress_bar.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddPayment;
  final VoidCallback onViewDetail;
  final bool isArchived;

  const DebtCard({
    super.key,
    required this.debt,
    required this.onEdit,
    required this.onDelete,
    required this.onAddPayment,
    required this.onViewDetail, 
    required this.isArchived,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onViewDetail,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                  itemBuilder: (_) {

                      if (isArchived) {
                        return [
                          PopupMenuItem(
                            onTap: onDelete,
                            child: const Text(
                              "Eliminar",
                            ),
                          ),
                        ];
                      }

                      return [
                        PopupMenuItem(
                          onTap: onEdit,
                          child: const Text(
                            "Editar",
                          ),
                        ),
                        PopupMenuItem(
                          onTap: onDelete,
                          child: const Text(
                            "Eliminar",
                          ),
                        ),
                      ];
                    },
                ),
              ],
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

            DebtProgressBar(
              progress: debt.progress,
            ),

            const SizedBox(height: 20),
            if (!isArchived)
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
          ],
        ),
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
        ),
      ],
    );
  }
}