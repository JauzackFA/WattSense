import '../../domain/models/history_detail_item_model.dart';
import '../../domain/models/summary_model.dart';
import '../dummy_data.dart';

/// Repository untuk semua data yang terkait dengan riwayat dan ringkasan.
class HistoryRepository {
  /// DIUBAH: Metode terpadu untuk mengambil data ringkasan bulanan.
  /// Metode ini akan digunakan oleh HomePage dan HistoryPage.
  Future<SummaryModel> getMonthlySummary() async {
    await Future.delayed(const Duration(seconds: 1));
    return SummaryModel(
      totalCost: 'Rp 1.280.000', // Nilai dari History Page
      totalConsumption: '950.50 kWh', // Nilai dari History Page
      budgetProgress: 0.6, // Nilai progress dari Home Page
    );
  }

  /// Mensimulasikan pengambilan data riwayat terbaru untuk Home Page.
  Future<List<HistoryDetailItemModel>> getRecentHistory() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return DummyData.historyItems.take(3).toList();
  }

  /// Mensimulasikan pengambilan semua data riwayat untuk History Page.
  Future<List<HistoryDetailItemModel>> getFullHistory() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return DummyData.historyItems;
  }
}
