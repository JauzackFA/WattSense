import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wattsense/presentation/pages/home_page/widget/action_button.dart';
import 'package:wattsense/presentation/pages/home_page/widget/history_section.dart';
import 'package:wattsense/presentation/pages/home_page/widget/summary_card.dart';
import 'package:wattsense/presentation/pages/profile_page/usage_configuration/cubit/configuration_cubit.dart';

// Import yang diperlukan
import '../../../domain/models/history_detail_item_model.dart';
import '../calculator_page/calculator_page.dart';
import '../graph_page/graph_page.dart';
import '../history_page/cubit/history_cubit.dart';
import '../history_page/history_page.dart';
import '../news_page/news_page.dart';
import '../profile_page/profile_page.dart';
// import '../usage_configuration_page/cubit/configuration_cubit.dart';
// import '../../widgets/home/action_button.dart';
// import '../../widgets/home/history_section.dart';
// import '../../widgets/home/summary_card.dart';

/// Halaman utama yang sekarang hanya bertugas membangun UI.
///
/// Halaman ini tidak lagi memiliki logika state sendiri, melainkan
/// mendengarkan perubahan dari [HistoryCubit] dan [ConfigurationCubit]
/// yang disediakan secara global.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // Sliver #1: AppBar Kustom
          _buildAppBar(context),

          // Sliver #2: Konten utama, dibangun menggunakan BlocBuilder
          // yang mendengarkan kedua Cubit.
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, historyState) {
              // Gunakan BlocBuilder kedua untuk mendapatkan state konfigurasi
              return BlocBuilder<ConfigurationCubit, ConfigurationState>(
                builder: (context, configState) {
                  // State: Loading atau Initial, tampilkan placeholder
                  if (historyState.status == HistoryStatus.loading ||
                      historyState.status == HistoryStatus.initial ||
                      configState.status == ConfigurationStatus.initial) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // State: Gagal memuat salah satu data
                  if (historyState.status == HistoryStatus.failure ||
                      configState.status == ConfigurationStatus.failure) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                            'Failed to load data: ${historyState.errorMessage ?? configState.errorMessage}'),
                      ),
                    );
                  }

                  // State: Sukses, bangun UI dengan data dari kedua state
                  final historyForHome =
                      historyState.fullHistory.take(3).toList();

                  final summary = historyState.summary;
                  final config = configState.configuration;

                  // Helper untuk mengubah string Rupiah menjadi double
                  double parseRupiah(String value) {
                    final cleanString = value.replaceAll(RegExp(r'[^0-9]'), '');
                    return double.tryParse(cleanString) ?? 0.0;
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // --- BAGIAN SUMMARY CARD ---
                        _buildSummaryContent(
                          totalConsumption: summary!.totalConsumption,
                          totalCostDisplay: summary.totalCost,
                          currentCost: parseRupiah(summary.totalCost),
                          costLimit: config.monthlyCostLimit,
                        ),
                        const SizedBox(height: 25),

                        // --- BAGIAN ACTION BUTTONS ---
                        _buildActionButtons(context),
                        const SizedBox(height: 25),

                        // --- BAGIAN HISTORY SECTION ---
                        HistorySection(
                          historyItems: historyForHome,
                          onSeeAllTapped: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Widget helper untuk membangun AppBar
  Widget _buildAppBar(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        child: Container(
          color: const Color(0xFF0BC2E7),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget helper untuk membangun tombol aksi
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          ActionButton(
              icon: Icons.add_circle_outline,
              label: 'Add Data',
              backgroundColor: Colors.lightBlue[100]!,
              iconColor: Colors.blue[700]!,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalculatorPage()));
              }),
          ActionButton(
              icon: Icons.show_chart,
              label: 'Graph',
              backgroundColor: Colors.teal[100]!,
              iconColor: Colors.teal[700]!,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GraphPage()));
              }),
          ActionButton(
              icon: Icons.lightbulb_outline,
              label: 'Tips & News',
              backgroundColor: Colors.yellow[100]!,
              iconColor: Colors.amber[700]!,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NewsPage()));
              }),
        ],
      ),
    );
  }

  /// Widget helper untuk membangun konten [SummaryCard].
  Widget _buildSummaryContent({
    required String totalConsumption,
    required String totalCostDisplay,
    required double currentCost,
    required double costLimit,
  }) {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xFF0BC2E7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          child: SummaryCard(
            totalConsumption: totalConsumption,
            totalCostDisplay: totalCostDisplay,
            currentCost: currentCost,
            costLimit: costLimit,
            themeColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Delegate untuk AppBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverAppBarDelegate({required this.child});
  @override
  double get minExtent => 100.0;
  @override
  double get maxExtent => 100.0;
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) =>
      child != oldDelegate.child;
}
