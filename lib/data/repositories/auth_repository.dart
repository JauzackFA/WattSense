import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../domain/models/auth_user_model.dart';

/// Model untuk data pengguna.
/// Field 'name' telah dihapus.

/// Repository untuk mengelola semua proses otentikasi.
class AuthRepository {
  final String _baseUrl =
      "https://wattsensebackend-production.up.railway.app/api/user";

  /// Helper untuk mengekstrak pesan error dari respons JSON.
  String _extractErrorMessage(String responseBody) {
    try {
      final data = jsonDecode(responseBody);
      return data['error'] ?? data['message'] ?? 'An unknown error occurred.';
    } catch (e) {
      return 'Failed to parse error response.';
    }
  }

  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('id', data['id']);
        await prefs.setString('email', data['email']);
        await prefs.setString('username', data['username']);
        return AuthUserModel(
          id: data['id'],
          email: data['email'],
          username: data['username'],
        );
      } else {
        throw Exception(
            'Login successful, but API response is missing user data. Please fix the backend to return the user object.');
      }
    } else {
      print('--- LOGIN GAGAL ---');
      print('Status Code: ${response.statusCode}');
      print('Response Body (Raw): ${response.body}');
      throw Exception(_extractErrorMessage(response.body));
    }
  }

  /// Mendaftarkan pengguna baru hanya dengan email dan password.
  /// Parameter 'name' telah dihapus.
  Future<AuthUserModel> signUp({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl), // POST to /api/user/
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      // Field 'name' telah dihapus dari body request.
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthUserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_extractErrorMessage(response.body));
    }
  }

  /// Memperbarui data pengguna berdasarkan ID.
  Future<void> updateUser({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response.body));
    }
    print('User with id $id updated successfully.');
  }

  /// Menghapus pengguna berdasarkan ID.
  Future<void> deleteUser({required String id}) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response.body));
    }
    print('User with id $id deleted successfully.');
  }

  /// Mengirimkan permintaan untuk mereset password.
  Future<void> forgotPassword({required String email}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response.body));
    }

    print('Password reset link sent to: $email');
  }

  /// ✅ Fungsi Logout: Menghapus data pengguna dari SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('email');
    await prefs.remove('username');
    print('--- LOGOUT BERHASIL --- Semua data pengguna dihapus.');
  }
}
