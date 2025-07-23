import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Pastikan path import ini sesuai struktur project Anda
import '../../../../domain/models/summary_model.dart';
import '../../../../domain/models/history_detail_item_model.dart';
import '../../../../data/repositories/history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryCubit(this._historyRepository) : super(HistoryState.initial());

  /// Mengambil seluruh data history dari repository dan update state
  Future<void> fetchHistoryPageData() async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final history = await _historyRepository.getHistory();

      final summary = _calculateSummary(history);
      final rooms = _extractRooms(history);

      emit(state.copyWith(
        status: HistoryStatus.success,
        summary: summary,
        fullHistory: history,
        filteredHistory: history,
        availableRooms: ['All Rooms', ...rooms],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Menambahkan data perangkat baru (optimistic UI + backend)
  Future<void> addDeviceToHistory(HistoryDetailItemModel newDevice) async {
    print('📦 [Cubit] Menerima perangkat baru: ${newDevice.toString()}');

    if (state.status != HistoryStatus.success) return;

    final optimisticHistory = [newDevice, ...state.fullHistory];
    emit(state.copyWith(fullHistory: optimisticHistory));
    applyFilter();

    try {
      final savedDevice =
          await _historyRepository.addDeviceToHistory(newDevice);
      print(
          '💾 [Cubit] Perangkat berhasil disimpan, data dari server: ${savedDevice.toString()}');

      // Ganti item pertama dengan item dari server
      final updatedHistory = [savedDevice, ...state.fullHistory.skip(1)];
      final updatedSummary = _calculateSummary(updatedHistory);
      final updatedRooms = _extractRooms(updatedHistory);

      emit(state.copyWith(
        fullHistory: updatedHistory,
        summary: updatedSummary,
        availableRooms: ['All Rooms', ...updatedRooms],
        status: HistoryStatus.success,
      ));
      applyFilter();
    } catch (e) {
      print('❌ [Cubit] Gagal menyimpan perangkat: ${newDevice.toString()}');
      print('      Penyebab Error: ${e.toString()}');
      // Rollback jika gagal
      final rolledBackHistory =
          state.fullHistory.where((item) => item.id != newDevice.id).toList();
      emit(state.copyWith(
        fullHistory: rolledBackHistory,
        status: HistoryStatus.failure,
        errorMessage: "Gagal menambahkan perangkat: ${e.toString()}",
      ));
      applyFilter();
    }
  }

  /// Memfilter daftar riwayat berdasarkan bulan dan/atau ruangan
  void applyFilter({DateTime? month, String? room}) {
    final newMonth = month ?? state.selectedMonth;
    final newRoom = room ?? state.selectedRoom;

    final filtered = state.fullHistory.where((item) {
      final roomMatches = newRoom == 'All Rooms' || item.location == newRoom;
      return roomMatches;
    }).toList();

    emit(state.copyWith(
      selectedMonth: newMonth,
      selectedRoom: newRoom,
      filteredHistory: filtered,
    ));
  }

  /// Menghitung total konsumsi dan biaya dari daftar history
  SummaryModel _calculateSummary(List<HistoryDetailItemModel> history) {
    double totalKwh = 0.0;
    double totalCost = 0.0;

    for (var item in history) {
      final kwh =
          double.tryParse(item.consumption.replaceAll(' kWh', '')) ?? 0.0;
      final cost =
          double.tryParse(item.cost.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;

      totalKwh += kwh;
      totalCost += cost;
    }

    return SummaryModel(
      totalConsumption: '${totalKwh.toStringAsFixed(1)} kWh',
      totalCost: 'Rp ${totalCost.toStringAsFixed(0)}',
      budgetProgress: 0.0, // Sesuaikan jika ada logika budget
    );
  }

  List<String> _extractRooms(List<HistoryDetailItemModel> list) {
    return list.map((e) => e.location).toSet().toList();
  }
}
