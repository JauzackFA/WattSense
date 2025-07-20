import 'package:flutter/material.dart';

/// Widget tombol aksi yang menampilkan ikon dan label dengan interaksi tap.
///
/// Widget ini memungkinkan pengguna untuk menekan tombol yang menampilkan ikon dan label.
/// Saat tombol ditekan, fungsi [onTap] akan dipanggil. Widget ini juga memungkinkan untuk
/// mengubah warna latar belakang dan warna ikon sesuai dengan parameter yang diberikan.
///
/// **Contoh Penggunaan:**
/// ```dart
/// ActionButton(
///   icon: Icons.add,
///   label: 'Tambah',
///   backgroundColor: Colors.blue,
///   iconColor: Colors.white,
///   onTap: () {
///     // Tindakan yang diambil saat tombol ditekan
///   },
/// );
/// ```
///
/// **Parameter:**
/// - [icon]: Ikon yang ditampilkan pada tombol, menggunakan [IconData].
/// - [label]: Teks label yang ditampilkan di bawah ikon.
/// - [backgroundColor]: Warna latar belakang tombol.
/// - [iconColor]: Warna ikon yang ditampilkan.
/// - [onTap]: Fungsi yang dipanggil saat tombol ditekan.

class ActionButton extends StatelessWidget {
  final IconData icon; // Ikon yang ditampilkan pada tombol
  final String label; // Label teks di bawah ikon
  final Color backgroundColor; // Warna latar belakang tombol
  final Color iconColor; // Warna ikon
  final VoidCallback onTap; // Fungsi callback saat tombol ditekan

  /// Membuat widget [ActionButton].
  ///
  /// Konstruktor ini menerima ikon, label, warna latar belakang, warna ikon,
  /// dan fungsi yang dipanggil saat tombol ditekan.
  ///
  /// [icon] adalah ikon yang ditampilkan pada tombol menggunakan [IconData].
  /// [label] adalah teks yang ditampilkan di bawah ikon.
  /// [backgroundColor] adalah warna latar belakang tombol.
  /// [iconColor] adalah warna ikon yang ditampilkan.
  /// [onTap] adalah fungsi yang dipanggil saat tombol ditekan.
  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: InkWell(
          onTap: onTap, // Fungsi callback saat tombol ditekan
          borderRadius:
              BorderRadius.circular(15.0), // Sudut yang melengkung pada tombol
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: backgroundColor, // Warna latar belakang tombol
              borderRadius:
                  BorderRadius.circular(15.0), // Sudut tombol melengkung
              boxShadow: [
                BoxShadow(
                  color: Colors.grey
                      .withOpacity(0.15), // Efek bayangan pada tombol
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Menyusun elemen secara vertikal
              children: [
                Icon(icon,
                    size: 35,
                    color: iconColor), // Menampilkan ikon dengan warna tertentu
                const SizedBox(height: 8), // Jarak antara ikon dan teks
                Text(
                  label, // Label teks di bawah ikon
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: iconColor, // Warna teks
                    fontWeight: FontWeight.w500,
                    fontSize: 13, // Ukuran font untuk label
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
