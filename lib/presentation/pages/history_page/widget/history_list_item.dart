import 'package:flutter/material.dart';
import '../../../../domain/models/history_detail_item_model.dart';

/// Widget kustom yang reusable untuk setiap item dalam daftar riwayat.
/// Dapat menampilkan atau menyembunyikan info konsumsi, serta menyesuaikan gaya.
class HistoryListItem extends StatelessWidget {
  final HistoryDetailItemModel item;

  const HistoryListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan apakah ini tampilan untuk Home Page (tanpa konsumsi)
    final bool isHomePageView = item.consumption == null;

    // Buat dekorasi secara kondisional.
    // Di History Page, setiap item adalah kartu dengan sudut melengkung.
    // Di Home Page, item tidak memiliki dekorasi sendiri karena berada di dalam kartu yang lebih besar.
    final BoxDecoration? decoration = !isHomePageView
        ? BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(15.0), // Menambahkan BorderRadius
          )
        : null; // Tidak ada dekorasi untuk tampilan di Home Page

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: decoration, // Terapkan dekorasi kondisional
      child: Row(
        // Sejajarkan semua anak widget ke atas (start)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon di sebelah kiri
          Icon(item.icon, color: Colors.blue[700], size: 30),
          const SizedBox(width: 15),

          // Info Perangkat (Nama & Lokasi) di tengah
          // Expanded akan mengambil semua ruang yang tersisa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.deviceName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Beri sedikit jarak jika di Home Page agar sejajar
                if (isHomePageView) const SizedBox(height: 5),
                Text(
                  item.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          // DIUBAH: Jarak horizontal diperbesar agar tidak terlalu dekat
          const SizedBox(width: 16),

          // Info Biaya (dan Konsumsi) di sebelah kanan
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Jika ini tampilan Home Page (konsumsi null)
              if (isHomePageView)
                Text(
                  item.cost,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, // DIBUAT TEBAL
                    fontSize: 16, // Ukuran font sama dengan nama perangkat
                  ),
                )
              // Jika ini tampilan History Page (konsumsi ada)
              else ...[
                Text(
                  item.consumption!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  item.cost,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
