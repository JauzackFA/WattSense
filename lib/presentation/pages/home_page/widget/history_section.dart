import 'package:flutter/material.dart';
import '../../../../domain/models/history_detail_item_model.dart';
import '../../history_page/widget/history_list_item.dart';

/// Widget bagian riwayat yang menampilkan daftar item riwayat dan tombol "See all".
///
/// Widget ini menampilkan header dengan judul "History" dan tombol untuk melihat semua riwayat.
/// Di bawahnya, terdapat daftar item riwayat. Widget ini menggunakan model yang
/// sama dengan halaman riwayat detail untuk konsistensi.
class HistorySection extends StatelessWidget {
  final List<HistoryDetailItemModel> historyItems; // DIUBAH ke model yang baru
  final VoidCallback onSeeAllTapped;

  const HistorySection({
    super.key,
    required this.historyItems,
    required this.onSeeAllTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5), // Padding disesuaikan
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Judul dan tombol "See all"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onSeeAllTapped,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Memberi jarak antara header dan list
          // Daftar item riwayat
          if (historyItems.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text('No history available.'),
            )
          else
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return HistoryListItem(
                  item: item,
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            ),
        ],
      ),
    );
  }
}
