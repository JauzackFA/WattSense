import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart'; // Import untuk 'map' dan 'toSet'

import '../../../../domain/models/summary_model.dart';
import '../../../../domain/models/history_detail_item_model.dart';
import '../../../../data/repositories/history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryCubit(this._historyRepository) : super(HistoryState.initial());

  Future<void> fetchHistoryPageData() async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final results = await Future.wait([
        _historyRepository.getMonthlySummary(),
        _historyRepository.getFullHistory(),
      ]);

      final summary = results[0] as SummaryModel;
      final history = results[1] as List<HistoryDetailItemModel>;

      // Dapatkan daftar ruangan unik dari data
      final rooms = history.map((item) => item.location).toSet().toList();

      emit(state.copyWith(
        status: HistoryStatus.success,
        summary: summary,
        fullHistory: history,
        filteredHistory: history, // Awalnya tampilkan semua
        availableRooms: ['All Rooms', ...rooms],
      ));
    } catch (e) {
      emit(state.copyWith(
          status: HistoryStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Memfilter daftar riwayat berdasarkan kriteria yang dipilih.
  void applyFilter({DateTime? month, String? room}) {
    final newMonth = month ?? state.selectedMonth;
    final newRoom = room ?? state.selectedRoom;

    // Lakukan filter pada daftar riwayat yang asli (fullHistory)
    final filteredList = state.fullHistory.where((item) {
      // Untuk sekarang, kita hanya filter berdasarkan ruangan.
      // Filter bulan memerlukan data tanggal di dalam model.
      final roomMatches = newRoom == 'All Rooms' || item.location == newRoom;
      return roomMatches;
    }).toList();

    emit(state.copyWith(
      selectedMonth: newMonth,
      selectedRoom: newRoom,
      filteredHistory: filteredList,
    ));
  }

  void addDeviceToHistory(HistoryDetailItemModel newDevice) {
    final updatedHistory = List<HistoryDetailItemModel>.from(state.fullHistory)
      ..insert(0, newDevice);

    // TODO: Perbarui summary

    emit(state.copyWith(
      fullHistory: updatedHistory,
      status: HistoryStatus.success,
    ));

    // Terapkan kembali filter yang sedang aktif
    applyFilter();
  }
}
