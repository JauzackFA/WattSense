import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

// Pastikan path import ini benar sesuai struktur folder Anda
import '../../../../domain/models/summary_model.dart';
import '../../../../domain/models/history_detail_item_model.dart';
import '../../../../data/repositories/history_repository.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _historyRepository;

  HistoryCubit(this._historyRepository) : super(HistoryState.initial());

  /// [MODIFIKASI] Mengambil data dari repository backend
  Future<void> fetchHistoryPageData() async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      // Hanya panggil satu method untuk mendapatkan semua history
      final history = await _historyRepository.getHistory();

      // Hitung summary di sisi klien dari data history yang didapat
      final summary = _calculateSummary(history);

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

  /// [MODIFIKASI] Menambah perangkat baru dan mengirimnya ke backend
  Future<void> addDeviceToHistory(HistoryDetailItemModel newDevice) async {
    // Pastikan state saat ini adalah success
    if (state.status != HistoryStatus.success) return;

    // 1. Optimistic UI Update
    final optimisticHistory =
        List<HistoryDetailItemModel>.from(state.fullHistory)
          ..insert(0, newDevice);

    emit(state.copyWith(fullHistory: optimisticHistory));
    applyFilter(); // Terapkan filter ke daftar yang baru

    try {
      // 2. Panggil API untuk menyimpan data ke backend
      final createdDevice =
          await _historyRepository.addDeviceToHistory(newDevice);

      // 3. Jika berhasil, perbarui state dengan data valid dari server
      final finalHistory = List<HistoryDetailItemModel>.from(state.fullHistory);
      // Ganti item sementara dengan item yang sudah memiliki ID dari server
      finalHistory[0] = createdDevice;

      // Perbarui juga data summary dan daftar ruangan
      final summary = _calculateSummary(finalHistory);
      final rooms = finalHistory.map((item) => item.location).toSet().toList();

      emit(state.copyWith(
        fullHistory: finalHistory,
        summary: summary,
        availableRooms: ['All Rooms', ...rooms],
        status: HistoryStatus.success,
      ));
      // Terapkan filter lagi untuk memastikan konsistensi
      applyFilter();
    } catch (e) {
      // 4. Jika gagal, kembalikan state ke semula (rollback) dan tampilkan error
      emit(state.copyWith(
          fullHistory: state.fullHistory
              .where((item) => item.id != newDevice.id)
              .toList(),
          status: HistoryStatus.failure,
          errorMessage: "Failed to save device: ${e.toString()}"));
      applyFilter();
    }
  }

  /// Memfilter daftar riwayat berdasarkan kriteria yang dipilih.
  /// (Tidak ada perubahan di sini, method ini sudah benar)
  void applyFilter({DateTime? month, String? room}) {
    final newMonth = month ?? state.selectedMonth;
    final newRoom = room ?? state.selectedRoom;

    final filteredList = state.fullHistory.where((item) {
      // TODO: Tambahkan logika filter bulan jika model sudah memiliki tanggal
      final roomMatches = newRoom == 'All Rooms' || item.location == newRoom;
      return roomMatches;
    }).toList();

    emit(state.copyWith(
      selectedMonth: newMonth,
      selectedRoom: newRoom,
      filteredHistory: filteredList,
    ));
  }

  /// Helper untuk menghitung summary dari list history
  /// (Ini adalah contoh, sesuaikan dengan logika Anda)
  SummaryModel _calculateSummary(List<HistoryDetailItemModel> history) {
    double totalKwh = 0;
    // Asumsi format 'consumption' adalah "123.4 kWh"
    // Asumsi format 'cost' adalah "Rp 123.456"

    for (var item in history) {
      final kwhString = item.consumption.replaceAll(' kWh', '');
      totalKwh += double.tryParse(kwhString) ?? 0;
    }

    // Sesuaikan dengan field yang ada di SummaryModel Anda
    return SummaryModel(
      // 1. Ganti 'totalUsage' menjadi 'totalConsumption'
      totalConsumption: '${totalKwh.toStringAsFixed(1)} kWh',

      // Ini sudah benar
      totalCost:
          'Rp ...', // TODO: Anda perlu logika untuk menghitung total biaya

      // 2. Tambahkan parameter 'budgetProgress' yang wajib diisi
      // Untuk sementara, kita bisa beri nilai dummy 0.0
      budgetProgress: 0.0,

      // 3. Hapus parameter 'prediction' karena tidak ada di model
    );
  }
}
