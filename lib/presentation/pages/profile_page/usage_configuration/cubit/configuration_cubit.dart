import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../data/repositories/configuration_repository.dart';
import '../../../../../domain/models/configuration_model.dart';

part 'configuration_state.dart';

class ConfigurationCubit extends Cubit<ConfigurationState> {
  final ConfigurationRepository _configurationRepository;

  ConfigurationCubit(this._configurationRepository)
      : super(const ConfigurationState());

  /// Mengambil data konfigurasi awal.
  Future<void> fetchConfiguration() async {
    emit(state.copyWith(status: ConfigurationStatus.loading));
    try {
      final config = await _configurationRepository.getConfiguration();
      emit(state.copyWith(
          status: ConfigurationStatus.success, configuration: config));
    } catch (e) {
      emit(state.copyWith(
          status: ConfigurationStatus.failure, errorMessage: e.toString()));
    }
  }

  /// Memperbarui batas biaya bulanan.
  Future<void> updateCostLimit(double newLimit) async {
    emit(state.copyWith(status: ConfigurationStatus.loading));
    try {
      await _configurationRepository.updateMonthlyCostLimit(newLimit);
      // Ambil ulang konfigurasi terbaru setelah update
      await fetchConfiguration();
    } catch (e) {
      emit(state.copyWith(
          status: ConfigurationStatus.failure, errorMessage: e.toString()));
    }
  }
}
