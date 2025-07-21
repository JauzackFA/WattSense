import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/models/history_detail_item_model.dart';

class HistoryRepository {
  final String _baseUrl =
      "https://wattsensebackend-production.up.railway.app/api/roomDevice";

  String _extractErrorMessage(String responseBody) {
    try {
      final data = jsonDecode(responseBody);
      return data['error'] ?? data['message'] ?? 'An unknown error occurred.';
    } catch (e) {
      return 'Failed to parse error response.';
    }
  }

  /// Mengambil semua data history dari backend.
  Future<List<HistoryDetailItemModel>> getHistory() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Ubah setiap item di list JSON menjadi objek HistoryDetailItemModel
      return data.map((json) => HistoryDetailItemModel.fromJson(json)).toList();
    } else {
      throw Exception(_extractErrorMessage(response.body));
    }
  }

  /// Menambahkan perangkat baru ke history di backend.
  Future<HistoryDetailItemModel> addDeviceToHistory(
      HistoryDetailItemModel device) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(device.toJson()),
    );

    if (response.statusCode == 201) {
      // 201 Created
      // Backend akan mengembalikan data yang baru saja dibuat, lengkap dengan ID
      return HistoryDetailItemModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_extractErrorMessage(response.body));
    }
  }

  /// Menghapus item history dari backend berdasarkan ID.
  Future<void> deleteHistoryItem(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      // 204 No Content
      throw Exception(_extractErrorMessage(response.body));
    }
    // Tidak perlu mengembalikan apa pun jika berhasil
  }
}
