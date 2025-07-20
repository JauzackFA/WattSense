import 'package:intl/intl.dart';

class CalculatorService {
  static const double _electricityRate = 1700.0;

  static double calculateMonthlyKwh(
      {required double power, required double duration}) {
    if (power <= 0 || duration <= 0) return 0.0;
    return (power / 1000) * duration * 30;
  }

  static double calculateMonthlyCost(
      {required double power, required double duration}) {
    final double monthlyKwh =
        calculateMonthlyKwh(power: power, duration: duration);
    return monthlyKwh * _electricityRate;
  }

  static String formatToRupiah(double cost) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(cost);
  }
}
