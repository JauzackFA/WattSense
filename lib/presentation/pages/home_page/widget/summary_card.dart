import 'package:flutter/material.dart';

/// Widget kartu ringkasan yang menampilkan informasi konsumsi dan biaya.
///
/// Widget ini secara dinamis menghitung dan menampilkan progress bar
/// berdasarkan biaya saat ini terhadap batas biaya yang ditentukan.
/// Ia juga akan menampilkan peringatan jika batas biaya terlampaui.
class SummaryCard extends StatelessWidget {
  final String totalConsumption;
  final String
      totalCostDisplay; // String untuk ditampilkan (e.g., "Rp 990.400")
  final double currentCost; // Nilai double untuk perhitungan (e.g., 990400.0)
  final double costLimit; // Nilai double untuk batas biaya
  final Color themeColor;

  const SummaryCard({
    super.key,
    required this.totalConsumption,
    required this.totalCostDisplay,
    required this.currentCost,
    required this.costLimit,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung progres budget. Pastikan costLimit tidak nol untuk menghindari error.
    final double budgetProgress =
        (costLimit > 0) ? currentCost / costLimit : 0.0;

    // Menentukan apakah batas telah terlampaui.
    final bool isLimitExceeded = budgetProgress >= 1.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Summary',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Total Consumption This Month',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            totalConsumption,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // Menampilkan total biaya dari parameter
          Text(
            totalCostDisplay,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          // Indikator progres anggaran
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              // clamp memastikan nilai progress selalu antara 0.0 dan 1.0
              value: budgetProgress.clamp(0.0, 1.0),
              backgroundColor: Colors.black.withOpacity(0.1),
              // Warna progress bar akan menjadi merah jika limit terlampaui
              valueColor: AlwaysStoppedAnimation<Color>(
                isLimitExceeded ? Colors.redAccent : const Color(0xFFFFD446),
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 15),

          // DIUBAH: Menampilkan peringatan hanya jika batas terlampaui
          if (isLimitExceeded)
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Cost limit exceeded!',
                  style: TextStyle(
                    color: Colors.red[800],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          // Jika tidak, tampilkan widget kosong untuk menjaga layout
          else
            const SizedBox(
                height: 20), // Placeholder agar tinggi kartu konsisten

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
