/// Model untuk menampung data ringkasan dari API.
class SummaryModel {
  final String totalConsumption;
  final String totalCost;
  final double budgetProgress;

  SummaryModel({
    required this.totalConsumption,
    required this.totalCost,
    required this.budgetProgress,
  });

  // Anda bisa mengabaikan bagian ini untuk saat ini.
  // Ini disiapkan untuk saat rekan back-end Anda sudah menyediakan API.
  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalConsumption: json['total_consumption'],
      totalCost: json['total_cost'],
      // Pastikan data dari JSON di-casting dengan benar ke double
      budgetProgress: (json['budget_progress'] as num).toDouble(),
    );
  }
}
