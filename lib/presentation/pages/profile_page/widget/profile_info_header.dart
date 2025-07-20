import 'package:flutter/material.dart';

/// Widget untuk menampilkan foto profil dan nama pengguna.
class ProfileInfoHeader extends StatelessWidget {
  /// Menerima ImageProvider agar bisa fleksibel menggunakan
  /// NetworkImage, AssetImage, atau lainnya.
  final ImageProvider backgroundImage;
  final String name;

  // DIUBAH: Kata kunci 'const' dihapus untuk mengatasi error hot reload.
  const ProfileInfoHeader({
    super.key,
    required this.backgroundImage,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: backgroundImage,
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
