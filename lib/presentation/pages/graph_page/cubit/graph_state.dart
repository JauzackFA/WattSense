part of 'graph_cubit.dart';

enum GraphStatus { initial, loading, success, failure }

enum TimePeriod { day, week, month }

class GraphState extends Equatable {
  final GraphStatus status;
  final TimePeriod selectedPeriod;
  final GraphPageData? graphData;
  final String? errorMessage;

  const GraphState({
    this.status = GraphStatus.initial,
    this.selectedPeriod = TimePeriod.day,
    this.graphData,
    this.errorMessage,
  });

  GraphState copyWith({
    GraphStatus? status,
    TimePeriod? selectedPeriod,
    GraphPageData? graphData,
    String? errorMessage,
  }) {
    return GraphState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      graphData: graphData ?? this.graphData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedPeriod, graphData, errorMessage];
}
