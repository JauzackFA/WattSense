part of 'history_cubit.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  static const List<String> defaultRooms = ['All Rooms'];

  final HistoryStatus status;
  final SummaryModel? summary;
  final List<HistoryDetailItemModel> fullHistory;
  final List<HistoryDetailItemModel> filteredHistory;
  final DateTime selectedMonth;
  final String selectedRoom;
  final List<String> availableRooms;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.summary,
    this.fullHistory = const [],
    this.filteredHistory = const [],
    required this.selectedMonth,
    this.selectedRoom = 'All Rooms',
    this.availableRooms = defaultRooms,
    this.errorMessage,
  });

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
        errorMessage,
      ];
}

extension HistoryStateX on HistoryState {
  bool get isInitial => status == HistoryStatus.initial;
  bool get isLoading => status == HistoryStatus.loading;
  bool get isSuccess => status == HistoryStatus.success;
  bool get isFailure => status == HistoryStatus.failure;
}
