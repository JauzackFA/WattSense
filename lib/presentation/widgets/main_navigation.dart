// lib/presentation/widgets/main_navigation.dart
import 'package:flutter/material.dart';
import '../pages/home_page/home_page.dart';
import '../pages/news_page/news_page.dart';
import '../pages/calculator_page/calculator_page.dart';
import '../pages/graph_page/graph_page.dart';
import '../pages/profile_page/profile_page.dart';
import 'bottom_navigation.dart';

/// Widget navigasi utama yang mengatur tampilan halaman dan navigasi antar halaman.
///
/// Widget ini menampilkan berbagai halaman seperti Home, News, Calculator, History, dan Profile
/// dengan menggunakan [BottomNavigation] untuk menavigasi antar halaman.
///
/// **Contoh Penggunaan:**
/// ```dart
/// MainNavigation()
/// ```
///
/// **Deskripsi:**
/// - [selectedIndex]: Menentukan halaman yang saat ini ditampilkan (indeks halaman).
/// - [onItemTapped]: Fungsi yang dipanggil ketika item pada bottom navigation ditekan.

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // Indeks halaman yang dipilih

  // Daftar halaman yang dapat dipilih
  static const List<Widget> _pages = <Widget>[
    HomePage(), // Halaman Home
    NewsPage(), // Halaman News
    CalculatorPage(), // Halaman Calculator
    GraphPage(), // Halaman History
    ProfilePage(), // Halaman Profile
  ];

  /// Fungsi untuk menangani perubahan tab ketika item bottom navigation dipilih.
  ///
  /// Fungsi ini akan memperbarui [selectedIndex] untuk menunjukkan halaman yang dipilih.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Memperbarui halaman yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman berdasarkan indeks yang dipilih
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      // Menambahkan bottom navigation bar untuk memilih halaman
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped, // Menangani item yang dipilih
      ),
    );
  }
}
