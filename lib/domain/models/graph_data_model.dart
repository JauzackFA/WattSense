import 'package:fl_chart/fl_chart.dart';

/// Model untuk menampung seluruh data yang dibutuhkan oleh GraphPage.
class GraphPageData {
  final UsageSummary summary;
  final List<FlSpot> chartData;

  GraphPageData({
    required this.summary,
    required this.chartData,
  });
}

/// Model untuk data ringkasan penggunaan (harian, mingguan, bulanan).
class UsageSummary {
  final String dailyUsage;
  final String weeklyUsage;
  final String monthlyUsage;

  UsageSummary({
    required this.dailyUsage,
    required this.weeklyUsage,
    required this.monthlyUsage,
  });

  // Di aplikasi nyata, ini bisa memiliki factory constructor fromJson.
}
