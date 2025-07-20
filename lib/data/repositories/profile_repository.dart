// import 'dart:convert';
import '../../domain/models/profile_model.dart';

/// Repository untuk mengelola data yang terkait dengan profil pengguna.
class ProfileRepository {
  // final String _baseUrl = "https://api.domain-anda.com/api"; // Contoh URL API

  /// Mensimulasikan pengambilan data profil dari server.
  Future<ProfileModel> getProfile() async {
    // Memberi jeda untuk mensimulasikan panggilan jaringan.
    await Future.delayed(const Duration(seconds: 1));

    // Mengembalikan data dummy.
    return ProfileModel(
      id: 'user-123',
      name: 'Mickey',
      email: 'wattsense01@gmail.com',
      phoneNumber: '081234567890',
      imageUrl: 'assets/images/dummy_photo.png', // Path ke aset lokal
    );
  }

  /// Mensimulasikan pembaruan data profil ke server.
  /// Menerima Map yang berisi data yang akan diubah, contoh: {'name': 'Mickey Baru'}
  Future<void> updateProfile(Map<String, dynamic> data) async {
    // Memberi jeda untuk mensimulasikan panggilan jaringan.
    await Future.delayed(const Duration(seconds: 1));
    print("Data yang dikirim ke API: $data");

    // Di aplikasi nyata, kodenya akan melakukan panggilan HTTP PATCH atau PUT.
    /*
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
    */

    // Untuk simulasi, kita anggap selalu berhasil.
    // Jika ingin mensimulasikan error, Anda bisa melempar Exception di sini.
    // throw Exception('Simulated network error');
  }
}
