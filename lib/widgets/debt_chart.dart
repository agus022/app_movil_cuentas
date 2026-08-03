import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DebtChart extends StatelessWidget {

  final double paid;
  final double pending;

  const DebtChart({
    super.key,
    required this.paid,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 160,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 45,
          sectionsSpace: 3,
          sections: [

            PieChartSectionData(
              value: paid,
              color: Colors.green,
              title: '',
            ),

            PieChartSectionData(
              value: pending,
              color: Colors.redAccent,
              title: '',
            ),
          ],
        ),
      ),
    );
  }
}