import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  /// Teks yang akan ditampilkan di dalam tombol.
  final String text;

  /// Fungsi yang akan dieksekusi saat tombol ditekan.
  final VoidCallback onPressed;

  /// Warna latar belakang tombol.
  final Color backgroundColor;

  /// Warna teks dan ikon di dalam tombol.
  final Color foregroundColor;

  /// (Opsional) Ikon yang akan ditampilkan di sebelah kiri teks.
  final IconData? iconData;

  const PrimaryActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.iconData, // Jadikan ikon opsional
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0, // Anda bisa mengatur ini sesuai kebutuhan
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Jika ada ikon, tampilkan ikon
          if (iconData != null) ...[
            Icon(iconData, size: 20),
            const SizedBox(width: 8),
          ],
          // Teks tombol
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
