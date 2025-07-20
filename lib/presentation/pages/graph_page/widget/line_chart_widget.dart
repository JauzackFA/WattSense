import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wattsense/presentation/pages/graph_page/cubit/graph_cubit.dart';

/// Widget yang bertanggung jawab untuk merender grafik garis (Line Chart).
///
/// Kode ini telah disempurnakan untuk mencakup label sumbu Y (kiri) dan
/// sorotan visual pada titik data tertinggi, sesuai dengan prototipe.
class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final TimePeriod period;

  const LineChartWidget({
    super.key,
    required this.spots,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    // Cari titik tertinggi untuk disorot dan untuk menentukan batas atas grafik.
    final FlSpot highestSpot = spots.isNotEmpty
        ? spots.reduce((curr, next) => curr.y > next.y ? curr : next)
        : const FlSpot(0, 0);

    final double topPadding =
        highestSpot.y * 0.3; // 30% padding di atas titik tertinggi

    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          // Menentukan batas sumbu X dan Y
          minY: 0,
          maxY: highestSpot.y + topPadding,

          // 1. Konfigurasi Interaksi Sentuhan (Tooltip)
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              // tooltipBgColor: const Color(0xFF0BC2E7),
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(0)} kWh',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                }).toList();
              },
            ),
            // Menggambar indikator sorotan khusus pada titik yang disentuh
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  const FlLine(
                      color: Colors.transparent), // Sembunyikan garis vertikal
                  FlDotData(
                    getDotPainter: (spot, percent, bar, index) {
                      // Ini adalah lingkaran kuning sebagai "halo"
                      return FlDotCirclePainter(
                        radius: 12,
                        color: Colors.yellow.withOpacity(0.5),
                        strokeWidth: 0,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),

          // 2. Konfigurasi Grid dan Border
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // 3. Konfigurasi Label Sumbu (Titles)
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 100, // Menampilkan label setiap 200 satuan
                getTitlesWidget: (value, meta) {
                  if (value == 0 || value > highestSpot.y + (topPadding * 0.5))
                    return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) =>
                    _bottomTitleWidgets(value, meta, period),
              ),
            ),
          ),

          // 4. Konfigurasi Data Garis Grafik
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.cyan[600],
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                // Logika untuk menampilkan dot hanya pada titik tertinggi
                checkToShowDot: (spot, barData) {
                  return spot == highestSpot;
                },
                getDotPainter: (spot, percent, barData, index) {
                  // Ini adalah dot biru yang lebih kecil di atas "halo"
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    // strokeColor: Colors.cyan[800],
                    strokeWidth: 3,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.4),
                    Colors.cyan.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk membangun widget label di sumbu X.
  Widget _bottomTitleWidgets(double value, TitleMeta meta, TimePeriod period) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.grey,
    );
    String text;
    switch (period) {
      case TimePeriod.day:
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        text = (value.toInt() >= 0 && value.toInt() < days.length)
            ? days[value.toInt()]
            : '';
        break;
      case TimePeriod.week:
        text = 'W${value.toInt() + 1}';
        break;
      case TimePeriod.month:
        const months = [
          'J',
          'F',
          'M',
          'A',
          'M',
          'J',
          'J',
          'A',
          'S',
          'O',
          'N',
          'D'
        ];
        text = (value.toInt() >= 0 && value.toInt() < months.length)
            ? months[value.toInt()]
            : '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10.0,
      child: Text(text, style: style),
    );
  }
}
