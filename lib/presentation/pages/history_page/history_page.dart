import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wattsense/presentation/pages/history_page/widget/history_filter_button.dart';
import 'package:wattsense/presentation/pages/history_page/widget/history_list_item.dart';
import 'package:wattsense/presentation/pages/history_page/widget/history_summary_section.dart';
import 'cubit/history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HistoryView();
  }
}

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text('History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state.status == HistoryStatus.loading ||
                  state.status == HistoryStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == HistoryStatus.failure) {
                return Center(
                    child: Text('Failed to load data: ${state.errorMessage}'));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Bagian Filter ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FilterButton(
                          text: DateFormat('MMMM yyyy')
                              .format(state.selectedMonth),
                          onTap: () => _showMonthPicker(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilterButton(
                          text: state.selectedRoom,
                          onTap: () =>
                              _showRoomPicker(context, state.availableRooms),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Ringkasan Total ---
                  HistorySummarySection(
                    totalCost: state.summary!.totalCost,
                    totalConsumption: state.summary!.totalConsumption,
                  ),
                  const SizedBox(height: 16),

                  // --- Daftar Riwayat ---
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: state.filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = state.filteredHistory[index];
                        return HistoryListItem(item: item);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Menampilkan dialog untuk memilih bulan.
  Future<void> _showMonthPicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: context.read<HistoryCubit>().state.selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      // Bisa ditambahkan builder untuk styling
    );

    if (selectedDate != null) {
      context.read<HistoryCubit>().applyFilter(month: selectedDate);
    }
  }

  /// Menampilkan dialog untuk memilih ruangan.
  Future<void> _showRoomPicker(BuildContext context, List<String> rooms) async {
    final selectedRoom = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select Room'),
          children: rooms.map((room) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, room),
              child: Text(room),
            );
          }).toList(),
        );
      },
    );

    if (selectedRoom != null) {
      context.read<HistoryCubit>().applyFilter(room: selectedRoom);
    }
  }
}
