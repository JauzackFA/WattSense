part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final SummaryModel? summary;
  final List<HistoryDetailItemModel>
      fullHistory; // Daftar asli dari server/dummy
  final List<HistoryDetailItemModel>
      filteredHistory; // Daftar yang sudah difilter
  final DateTime selectedMonth; // Filter bulan yang aktif
  final String selectedRoom; // Filter ruangan yang aktif
  final List<String> availableRooms; // Daftar semua ruangan yang ada
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.summary,
    this.fullHistory = const [],
    this.filteredHistory = const [],
    required this.selectedMonth,
    this.selectedRoom = 'All Rooms',
    this.availableRooms = const ['All Rooms'],
    this.errorMessage,
  });

  // Konstruktor awal
  factory HistoryState.initial() {
    return HistoryState(
      selectedMonth: DateTime.now(),
    );
  }

  HistoryState copyWith({
    HistoryStatus? status,
    SummaryModel? summary,
    List<HistoryDetailItemModel>? fullHistory,
    List<HistoryDetailItemModel>? filteredHistory,
    DateTime? selectedMonth,
    String? selectedRoom,
    List<String>? availableRooms,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      fullHistory: fullHistory ?? this.fullHistory,
      filteredHistory: filteredHistory ?? this.filteredHistory,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      availableRooms: availableRooms ?? this.availableRooms,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        summary,
        fullHistory,
        filteredHistory,
        selectedMonth,
        selectedRoom,
        availableRooms,
        errorMessage
      ];
}
