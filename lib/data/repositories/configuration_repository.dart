import '../../domain/models/configuration_model.dart';

/// Repository untuk mengelola data konfigurasi.
///
/// Ini mensimulasikan pengambilan dan penyimpanan data. Di aplikasi nyata,
/// ini akan terhubung ke database lokal (seperti SharedPreferences) atau API.
class ConfigurationRepository {
  // Nilai default dummy
  ConfigurationModel _currentConfig = ConfigurationModel(
    monthlyCostLimit: 1000000,
    monthlyUsageLimit: 700,
  );

  /// Mengambil konfigurasi saat ini.
  Future<ConfigurationModel> getConfiguration() async {
    // Simulasi jeda jaringan
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentConfig;
  }

  /// Memperbarui batas biaya bulanan.
  Future<void> updateMonthlyCostLimit(double newLimit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentConfig = ConfigurationModel(
      monthlyCostLimit: newLimit,
      monthlyUsageLimit: _currentConfig.monthlyUsageLimit,
    );
    print('New cost limit saved: $newLimit');
  }

  // TODO: Tambahkan metode untuk memperbarui batas penggunaan (usage limit)
}
