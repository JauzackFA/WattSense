import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../domain/models/history_detail_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  HistoryRepository({
    http.Client? httpClient,
    double? tariffPerKWh, // Rp per kWh untuk hitung biaya
  })  : _http = httpClient ?? http.Client(),
        _tariffPerKWh = tariffPerKWh ?? 1500; // default (ubah sesuai PLN)

  final http.Client _http;
  final double _tariffPerKWh;
  final String _baseUrl =
      "https://wattsensebackend-production.up.railway.app/api";

  // -----------------------
  // Utilities
  // -----------------------
  String _extractErrorMessage(String responseBody) {
    try {
      final data = jsonDecode(responseBody);
      return data['error'] ??
          data['message'] ??
          data['detail'] ??
          'An unknown error occurred.';
    } catch (_) {
      return 'Failed to parse error response.';
    }
  }

  Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json; charset=UTF-8',
      };

  // -----------------------
  // STEP 1: Room
  // -----------------------
  Future<Map<String, dynamic>> createRoom(Map<String, dynamic> roomData) async {
    final resp = await _http.post(
      Uri.parse("$_baseUrl/room"),
      headers: _jsonHeaders,
      body: jsonEncode(roomData),
    );
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception(_extractErrorMessage(resp.body));
  }

  // -----------------------
  // STEP 2: Device
  // -----------------------
  Future<Map<String, dynamic>> createDevice(
      Map<String, dynamic> deviceData) async {
    final resp = await _http.post(
      Uri.parse("$_baseUrl/device"),
      headers: _jsonHeaders,
      body: jsonEncode(deviceData),
    );
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception(_extractErrorMessage(resp.body));
  }

  // -----------------------
  // STEP 3: RoomDevice (History)
  // Backend sample response:
  // {
  //   "id": 1,
  //   "roomId": 4,
  //   "deviceId": 1,
  //   "userId": 2,
  //   "totalConsumption": 20,
  //   "duration": 1,
  //   "updatedAt": "...",
  //   "createdAt": "..."
  // }
  // -----------------------
  Future<Map<String, dynamic>> createRoomDeviceRaw(
      {required String roomId,
      required String deviceId,
      required int duration,
      required int userId,
      required int totalConsumption}) async {
    final resp = await _http.post(
      Uri.parse("$_baseUrl/roomDevice"),
      headers: _jsonHeaders,
      body: jsonEncode({
        'roomId': int.tryParse(roomId) ?? roomId,
        'deviceId': int.tryParse(deviceId) ?? deviceId,
        'duration': duration,
        'userId': userId,
        'totalCOnsuption': totalConsumption
      }),
    );
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception(_extractErrorMessage(resp.body));
  }

  // -----------------------
  // Flow Lengkap → kembalikan HistoryDetailItemModel (untuk UI)
  // -----------------------
  Future<HistoryDetailItemModel> createFullHistoryFlow({
    required String roomName,
    required String deviceName,
    required int deviceWatt,
    required int durationHours,
  }) async {
    print(
        '🚀 [Repository] Memulai flow API dengan data: room=$roomName, device=$deviceName, watt=$deviceWatt, duration=$durationHours jam');
    // 1. Dapatkan instance SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 2. Baca data integer dengan key 'id'.
    // Fungsi getInt() akan mengembalikan null jika key tidak ditemukan.
    final int userId = prefs.getInt('id') ?? 0;
    try {
      // 1. Room
      final room = await createRoom({
        'name': roomName,
        'userId': userId,
      });

      // 2. Device
      final device = await createDevice({
        'name': deviceName,
        'powerConsumption': deviceWatt,
      });

      // 3. RoomDevice
      var rd;
      if (room != null && device != null) {
        rd = await createRoomDeviceRaw(
            roomId: room['id'].toString(),
            deviceId: device['id'].toString(),
            duration: durationHours,
            userId: userId,
            totalConsumption: durationHours * deviceWatt);
      }

      // 4. Bangun model UI
      return _roomDeviceResponseToHistoryModel(
        room: room,
        device: device,
        roomDevice: rd,
      );
    } catch (e) {
      rethrow;
    }
  }

  // -----------------------
  // Ambil seluruh history (roomDevice list) → convert ke UI model.
  // NOTE: Karena endpoint /roomDevice tampaknya tidak meng-embed room/device,
  //       kamu perlu join manual. Di sini versi sederhana: fetch room & device
  //       map dulu (opsional: cache).
  // -----------------------
  Future<List<HistoryDetailItemModel>> getHistory() async {
    final resp = await _http.get(Uri.parse("$_baseUrl/roomDevice"));
    if (resp.statusCode != 200) {
      throw Exception(_extractErrorMessage(resp.body));
    }

    final List<dynamic> list = jsonDecode(resp.body) as List<dynamic>;

    // Ambil referensi room & device untuk mapping.
    // Ideal: bikin cache agar tidak panggil API berulang.
    final roomsById = await _fetchRoomsById();
    final devicesById = await _fetchDevicesById();

    return list.map((raw) {
      final rd = raw as Map<String, dynamic>;
      final room = roomsById[rd['roomId']];
      final device = devicesById[rd['deviceId']];
      return _roomDeviceResponseToHistoryModel(
        room: room,
        device: device,
        roomDevice: rd,
      );
    }).toList();
  }

  // -----------------------
  // Delete HistoryItem (roomDevice)
  // -----------------------
  Future<void> deleteHistoryItem(String id) async {
    final resp = await _http.delete(Uri.parse("$_baseUrl/roomDevice/$id"));
    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception(_extractErrorMessage(resp.body));
    }
  }

  // ======================================================
  // INTERNAL HELPERS
  // ======================================================

  // Konversi triple: room + device + roomDevice → HistoryDetailItemModel
  HistoryDetailItemModel _roomDeviceResponseToHistoryModel({
    required Map<String, dynamic>? room,
    required Map<String, dynamic>? device,
    required Map<String, dynamic> roomDevice,
  }) {
    final roomName = room?['name']?.toString() ?? 'Unknown Room';
    final deviceName = device?['name']?.toString() ?? 'Unknown Device';

    // totalConsumption dari backend: asumsi kWh (ubah kalau beda)
    final consumptionValue = _numToDouble(roomDevice['totalConsumption']);
    final consumptionStr = _formatConsumption(consumptionValue);

    // Biaya
    final costValue = consumptionValue * _tariffPerKWh;
    final costStr = _formatRupiah(costValue);

    return HistoryDetailItemModel(
      id: roomDevice['id'].toString(),
      icon: _mapDeviceNameToIcon(deviceName),
      deviceName: deviceName,
      location: roomName,
      consumption: consumptionStr,
      cost: costStr,
    );
  }

  // Ambil semua room → map id->room
  Future<Map<dynamic, Map<String, dynamic>>> _fetchRoomsById() async {
    final resp = await _http.get(Uri.parse("$_baseUrl/room"));
    if (resp.statusCode != 200) {
      throw Exception(_extractErrorMessage(resp.body));
    }
    final List list = jsonDecode(resp.body) as List;
    final Map<dynamic, Map<String, dynamic>> out = {};
    for (final r in list) {
      final m = r as Map<String, dynamic>;
      out[m['id']] = m;
      out[m['_id'] ?? m['id']] = m; // jaga-jaga
    }
    return out;
  }

  // Ambil semua device → map id->device
  Future<Map<dynamic, Map<String, dynamic>>> _fetchDevicesById() async {
    final resp = await _http.get(Uri.parse("$_baseUrl/device"));
    if (resp.statusCode != 200) {
      throw Exception(_extractErrorMessage(resp.body));
    }
    final List list = jsonDecode(resp.body) as List;
    final Map<dynamic, Map<String, dynamic>> out = {};
    for (final d in list) {
      final m = d as Map<String, dynamic>;
      out[m['id']] = m;
      out[m['_id'] ?? m['id']] = m;
    }
    return out;
  }

  // Number parsing safety
  double _numToDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  // Format consumption jadi "X kWh"
  String _formatConsumption(double kWh) {
    // kalau datanya Wh, ubah di sini: double kWh = wh / 1000;
    return "${kWh.toStringAsFixed(kWh >= 10 ? 0 : 2)} kWh";
  }

  // Format rupiah sederhana (tanpa locale package)
  String _formatRupiah(double value) {
    final intVal = value.round();
    final str = intVal.toString();
    final sb = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      sb.write(str[i]);
      count++;
      if (count == 3 && i != 0) {
        sb.write('.');
        count = 0;
      }
    }
    final rev = sb.toString().split('').reversed.join();
    return "Rp $rev";
  }

  // Map nama perangkat -> IconData
  IconData _mapDeviceNameToIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('ac')) return Icons.ac_unit;
    if (lower.contains('lamp') || lower.contains('light'))
      return Icons.lightbulb_outline;
    if (lower.contains('tv')) return Icons.tv;
    if (lower.contains('kulkas') || lower.contains('fridge'))
      return Icons.kitchen;
    if (lower.contains('fan')) return Icons.toys; // kipas angin
    return Icons.electrical_services_outlined;
  }

  Future<HistoryDetailItemModel> addDeviceToHistory(
    HistoryDetailItemModel item,
  ) async {
    print('📦 [Repository] Menerima item dari Cubit: ${item.toString()}');

    // Ganti dengan logika yang sesuai kebutuhanmu, misalnya pakai nilai default
    const defaultWatt = 100;
    const defaultDuration = 1;

    return await createFullHistoryFlow(
      roomName: item.location,
      deviceName: item.deviceName,
      deviceWatt: defaultWatt,
      durationHours: defaultDuration,
    );
  }
}
