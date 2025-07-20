import 'package:fl_chart/fl_chart.dart';
import '../../domain/models/graph_data_model.dart';
import '../../presentation/pages/graph_page/cubit/graph_cubit.dart';
// import '../../cubit/graph_cubit.dart'; // Import enum TimePeriod

/// Repository untuk mengelola data yang terkait dengan grafik.
class GraphRepository {
  /// Mensimulasikan pengambilan data grafik dari API berdasarkan periode.
  Future<GraphPageData> getGraphData(TimePeriod period) async {
    // Memberi jeda untuk mensimulasikan panggilan jaringan.
    await Future.delayed(const Duration(milliseconds: 800));

    // Mengembalikan data dummy berdasarkan periode yang dipilih.
    return GraphPageData(
      summary: _getDummySummary(),
      chartData: _getDummyChartData(period),
    );
  }

  // Helper untuk menyediakan data ringkasan dummy.
  UsageSummary _getDummySummary() {
    return UsageSummary(
      dailyUsage: '32 kWh',
      weeklyUsage: '186 kWh',
      monthlyUsage: '513 kWh',
    );
  }

  // Helper untuk menyediakan data grafik dummy yang berbeda-beda.
  List<FlSpot> _getDummyChartData(TimePeriod period) {
    switch (period) {
      case TimePeriod.day:
        return const [
          FlSpot(0, 150), // Mon
          FlSpot(1, 120), // Tue
          FlSpot(2, 280), // Wed
          FlSpot(3, 180), // Thu
          FlSpot(4, 450), // Fri
          FlSpot(5, 250), // Sat
          FlSpot(6, 320), // Sun
        ];
      case TimePeriod.week:
        return const [
          FlSpot(0, 210),
          FlSpot(1, 400),
          FlSpot(2, 320),
          FlSpot(3, 500),
        ];
      case TimePeriod.month:
        return const [
          FlSpot(0, 300),
          FlSpot(1, 200),
          FlSpot(2, 250),
          FlSpot(3, 400),
          FlSpot(4, 350),
          FlSpot(5, 500),
          FlSpot(6, 480),
          FlSpot(7, 600),
          FlSpot(8, 550),
          FlSpot(9, 700),
          FlSpot(10, 650),
          FlSpot(11, 750),
        ];
    }
  }
}
