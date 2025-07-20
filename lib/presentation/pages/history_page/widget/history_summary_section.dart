import 'package:flutter/material.dart';

/// Widget untuk menampilkan ringkasan total di Halaman Riwayat.
class HistorySummarySection extends StatelessWidget {
  final String totalCost;
  final String totalConsumption;

  const HistorySummarySection({
    super.key,
    required this.totalCost,
    required this.totalConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            label: 'Total Cost',
            value: totalCost,
          ),
          _SummaryItem(
            label: 'Total Consumption',
            value: totalConsumption,
          ),
        ],
      ),
    );
  }
}

/// Widget internal untuk setiap item dalam ringkasan.
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
