/// Model untuk menyimpan data konfigurasi pengguna.
class ConfigurationModel {
  final double monthlyCostLimit;
  final double monthlyUsageLimit;

  const ConfigurationModel({
    required this.monthlyCostLimit,
    required this.monthlyUsageLimit,
  });
}
