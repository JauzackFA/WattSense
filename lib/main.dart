import 'package:flutter/material.dart';
import 'package:wattsense/app.dart';

/// Fungsi utama untuk menjalankan aplikasi WattSense.
///
/// Fungsi ini adalah titik masuk aplikasi dan digunakan untuk memulai aplikasi dengan
/// memanggil [runApp] dan memberikan widget utama [MyApp] untuk dijalankan.
///
/// **Deskripsi:**
/// - Fungsi ini menginisialisasi aplikasi dan memulai eksekusi widget utama dengan
///   memanggil `runApp(const MyApp())`.

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi dengan widget utama MyApp
}
