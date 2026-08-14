import 'package:app_cuentas/screens/archived_debts_screen.dart';
import 'package:app_cuentas/screens/completion_screen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/debt.dart';
import '../models/payment.dart';
import '../services/debt_service.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/debt_card.dart';
import 'debt_detail_screen.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  List<Debt> activeDebts = [];
  List<Debt> archivedDebts = [];
  List<Debt> debts = [];
 
  @override
  void initState() {
    super.initState();
    loadDebts();
  }

  void loadDebts() {
    final allDebts = DebtService.getAll();

    activeDebts = allDebts
        .where(
          (d) => !d.isArchived,
        )
        .toList();

    archivedDebts = allDebts
        .where(
          (d) => d.isArchived,
        )
        .toList();

    setState(() {});
  }

double get totalAmount =>
    activeDebts.fold(
      0,
      (sum, d) => sum + d.totalAmount,
    );

double get totalPaid =>
    activeDebts.fold(
      0,
      (sum, d) => sum + d.paidAmount,
    );

double get totalPending =>
    activeDebts.fold(
      0,
      (sum, d) => sum + d.pendingAmount,
    );
  Future<void> addDebt() async {
    final name = TextEditingController();
    final amount = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: "Persona",
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Monto Total",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final debt = Debt(
                    id: const Uuid().v4(),
                    personName: name.text,
                    totalAmount: double.parse(
                      amount.text,
                    ),
                    payments: [],
                    createdAt: DateTime.now(),
                  );

                  await DebtService.add(
                    debt,
                  );

                  loadDebts();

                  if (mounted) {
                    Navigator.pop(
                      context,
                    );
                  }
                },
                child: const Text(
                  "Guardar",
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> editDebt(
    Debt debt,
  ) async {
    final name = TextEditingController(
      text: debt.personName,
    );

    final total = TextEditingController(
      text: debt.totalAmount.toString(),
    );

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Editar"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: total,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                debt.personName = name.text;

                debt.totalAmount = double.parse(
                  total.text,
                );

                await debt.save();

                loadDebts();

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: const Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  Future<void> addPayment(
    
    Debt debt,
  ) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Registrar Pago",
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Monto",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool completed = false;
                debt.payments.add(
                  Payment(
                    amount: double.parse(
                      controller.text,
                    ),
                    date: DateTime.now(),
                  ),
                );


                if (debt.pendingAmount <= 0) {
                  debt.isArchived = true;
                  completed = true;
                }
                await debt.save();
                loadDebts();

                if (completed && mounted) {

                  Navigator.pop(context);

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CompletionScreen(),
                    ),
                  );

                  return;
                }

                if (mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: const Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  Future<void> deleteDebt(
    Debt debt,
  ) async {
    await DebtService.delete(
      debt.id,
    );

    loadDebts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addDebt,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          "Teddy Contador",
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.archive,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ArchivedDebtsScreen(
                    debts: archivedDebts,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DashboardCard(
                  title: "Total",
                  value: "\$${totalAmount.toStringAsFixed(0)}",
                ),
                DashboardCard(
                  title: "Pagado",
                  value: "\$${totalPaid.toStringAsFixed(0)}",
                ),
              ],
            ),
            Row(
              children: [
                DashboardCard(
                  title: "Pendiente",
                  value: "\$${totalPending.toStringAsFixed(0)}",
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeDebts.length,
              itemBuilder: (_, index) {
                final debt = activeDebts[index];

                return DebtCard(
                  debt: debt,
                  onEdit: () => editDebt(debt),
                  onDelete: () => deleteDebt(debt),
                  onAddPayment: () => addPayment(debt),
                  onViewDetail: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DebtDetailScreen(
                          debt: debt,
                          onAddPayment: () => addPayment(debt),
                        ),
                      ),
                    ).then((_) {
                      loadDebts();
                    });
                  }, isArchived: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
