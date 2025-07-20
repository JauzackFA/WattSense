import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import 'package:fl_chart/fl_chart.dart';

import '../../../../data/repositories/graph_repository.dart';
import '../../../../domain/models/graph_data_model.dart';

part 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  final GraphRepository _graphRepository;

  GraphCubit(this._graphRepository) : super(const GraphState());

  Future<void> fetchGraphData(TimePeriod period) async {
    emit(state.copyWith(status: GraphStatus.loading, selectedPeriod: period));
    try {
      final data = await _graphRepository.getGraphData(period);
      emit(state.copyWith(status: GraphStatus.success, graphData: data));
    } catch (e) {
      emit(state.copyWith(
          status: GraphStatus.failure, errorMessage: e.toString()));
    }
  }
}
