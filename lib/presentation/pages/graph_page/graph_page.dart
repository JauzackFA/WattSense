import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wattsense/presentation/pages/graph_page/widget/line_chart_widget.dart';
import '../../../data/repositories/graph_repository.dart';
import 'cubit/graph_cubit.dart';

/// Entry point untuk Halaman Grafik, menyediakan GraphCubit.
class GraphPage extends StatelessWidget {
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GraphCubit(GraphRepository())..fetchGraphData(TimePeriod.day),
      child: const GraphView(),
    );
  }
}

/// Widget yang membangun UI untuk Halaman Grafik.
class GraphView extends StatelessWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'Graph',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DIUBAH: Membungkus Text dan Tombol Toggle dalam satu Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Kunci untuk menyejajarkan
                  children: [
                    const Text(
                      'Watt',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    // Memberi lebar agar toggle tidak terlalu besar
                    SizedBox(width: 200, child: _buildPeriodToggle(context)),
                  ],
                ),
                const SizedBox(height: 32),

                BlocBuilder<GraphCubit, GraphState>(
                  builder: (context, state) {
                    if (state.status == GraphStatus.loading ||
                        state.status == GraphStatus.initial) {
                      return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state.status == GraphStatus.failure) {
                      return SizedBox(
                        height: 250,
                        child:
                            Center(child: Text('Error: ${state.errorMessage}')),
                      );
                    }
                    if (state.graphData != null) {
                      return LineChartWidget(
                          spots: state.graphData!.chartData,
                          period: state.selectedPeriod);
                    }
                    return const SizedBox(
                        height: 250,
                        child: Center(child: Text('No data available')));
                  },
                ),
                const SizedBox(height: 40),

                BlocBuilder<GraphCubit, GraphState>(
                  builder: (context, state) {
                    if (state.status == GraphStatus.success &&
                        state.graphData != null) {
                      final summary = state.graphData!.summary;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _UsageInfoRow(
                              label: 'Daily Usage', value: summary.dailyUsage),
                          _UsageInfoRow(
                              label: 'Weekly Usage',
                              value: summary.weeklyUsage),
                          _UsageInfoRow(
                              label: 'Monthly Usage',
                              value: summary.monthlyUsage),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _UsageInfoRow(label: 'Daily Usage', value: '...'),
                        _UsageInfoRow(label: 'Weekly Usage', value: '...'),
                        _UsageInfoRow(label: 'Monthly Usage', value: '...'),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodToggle(BuildContext context) {
    return BlocBuilder<GraphCubit, GraphState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: TimePeriod.values.map((period) {
              final isSelected = state.selectedPeriod == period;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      context.read<GraphCubit>().fetchGraphData(period),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3)
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        period.name[0].toUpperCase() + period.name.substring(1),
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black87 : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _UsageInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _UsageInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
