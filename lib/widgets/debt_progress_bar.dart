import 'package:flutter/material.dart';

class DebtProgressBar extends StatelessWidget {
  final double progress;

  const DebtProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {

    final paidPercent =
        (progress * 100).clamp(0, 100);

    final pendingPercent =
        100 - paidPercent;

    return Column(
      children: [

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${paidPercent.toStringAsFixed(0)}% Pagado",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${pendingPercent.toStringAsFixed(0)}% Debe",
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius:
              BorderRadius.circular(100),
          child: SizedBox(
            height: 14,
            child: Row(
              children: [

                Expanded(
                  flex: paidPercent.toInt(),
                  child: Container(
                    color: Colors.green,
                  ),
                ),

                Expanded(
                  flex: pendingPercent.toInt(),
                  child: Container(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}