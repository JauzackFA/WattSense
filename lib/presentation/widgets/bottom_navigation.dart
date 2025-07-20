import 'package:flutter/material.dart';

/// Widget Bottom Navigation yang menampilkan ikon dan label untuk navigasi antar halaman.
///
/// Widget ini menampilkan bar navigasi di bagian bawah layar dengan beberapa item yang dapat dipilih.
/// Setiap item memiliki ikon dan label yang dapat disesuaikan. Warna ikon berubah tergantung pada item yang dipilih.
///
/// **Contoh Penggunaan:**
/// ```dart
/// BottomNavigation(
///   selectedIndex: 0,  // Indeks item yang dipilih (misalnya 0 untuk 'Home')
///   onItemTapped: (index) {
///     // Tindakan yang diambil saat item dipilih
///   },
/// );
/// ```
///
/// **Parameter:**
/// - [selectedIndex]: Indeks item yang saat ini dipilih pada bottom navigation.
/// - [onItemTapped]: Fungsi callback yang dipanggil saat item pada bottom navigation ditekan.

class BottomNavigation extends StatelessWidget {
  final int selectedIndex; // Indeks item yang dipilih
  final Function(int) onItemTapped; // Fungsi callback saat item dipilih

  /// Membuat widget [BottomNavigation].
  ///
  /// Konstruktor ini menerima indeks item yang dipilih dan fungsi [onItemTapped] yang dipanggil saat
  /// item bottom navigation ditekan.
  ///
  /// [selectedIndex] adalah indeks item yang dipilih (misalnya, 0 untuk 'Home').
  /// [onItemTapped] adalah fungsi callback yang dipanggil ketika item ditekan.
  BottomNavigation({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70, // Menambah tinggi BottomNavigationBar
      decoration: const BoxDecoration(
        color: Colors.white, // Latar belakang untuk bottom navigation
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Warna shadow
            offset: Offset(0, -1), // Posisi shadow (ke atas sedikit)
            blurRadius: 2, // Seberapa buram shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex, // Menentukan item yang dipilih
        onTap: onItemTapped, // Fungsi untuk menangani perubahan tab
        selectedItemColor: const Color(0xFF0BC2E7), // Warna ikon yang dipilih
        unselectedItemColor: Colors.grey, // Warna ikon yang tidak dipilih
        type: BottomNavigationBarType
            .fixed, // Menonaktifkan animasi dan menjaga posisi ikon tetap
        showSelectedLabels: true, // Menampilkan label saat item dipilih
        showUnselectedLabels: true, // Menampilkan label saat item tidak dipilih
        items: <BottomNavigationBarItem>[
          // Item untuk Home
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icon_home.png',
              width: 24,
              height: 24,
              color: selectedIndex == 0
                  ? const Color(
                      0xFF0BC2E7) // Mengubah warna berdasarkan index yang dipilih
                  : const Color(0xFF484C52),
            ),
            label: 'Home',
          ),
          // Item untuk News
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icon_news.png',
              width: 24,
              height: 24,
              color: selectedIndex == 1
                  ? const Color(0xFF0BC2E7)
                  : const Color(0xFF484C52),
            ),
            label: 'News',
          ),
          // Item untuk Calculator
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icon_calculator.png',
              width: 24,
              height: 24,
              color: selectedIndex == 2
                  ? const Color(0xFF0BC2E7)
                  : const Color(0xFF484C52),
            ),
            label: 'Calculator',
          ),
          // Item untuk History
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icon_graph.png',
              width: 24,
              height: 24,
              color: selectedIndex == 3
                  ? const Color(0xFF0BC2E7)
                  : const Color(0xFF484C52),
            ),
            label: 'Graph',
          ),
          // Item untuk Profile
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icon_profile.png',
              width: 24,
              height: 24,
              color: selectedIndex == 4
                  ? const Color(0xFF0BC2E7)
                  : const Color(0xFF484C52),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
