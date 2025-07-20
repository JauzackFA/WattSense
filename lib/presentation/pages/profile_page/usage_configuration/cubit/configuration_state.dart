part of 'configuration_cubit.dart';

enum ConfigurationStatus { initial, loading, success, failure }

class ConfigurationState extends Equatable {
  final ConfigurationStatus status;
  final ConfigurationModel configuration;
  final String? errorMessage;

  const ConfigurationState({
    this.status = ConfigurationStatus.initial,
    // Nilai awal default
    this.configuration = const ConfigurationModel(
      monthlyCostLimit: 1000000,
      monthlyUsageLimit: 700,
    ),
    this.errorMessage,
  });

  ConfigurationState copyWith({
    ConfigurationStatus? status,
    ConfigurationModel? configuration,
    String? errorMessage,
  }) {
    return ConfigurationState(
      status: status ?? this.status,
      configuration: configuration ?? this.configuration,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, configuration, errorMessage];
}

// Tambahkan const ke konstruktor ConfigurationModel agar bisa digunakan di sini
// di file lib/domain/models/configuration_model.dart:
// const ConfigurationModel({...});
