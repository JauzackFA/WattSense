import 'package:flutter/material.dart';

class HistoryDetailItemModel {
  final String id; // Penting untuk interaksi dengan backend
  final IconData icon; // Icon tidak akan dikirim ke backend, ini untuk UI
  final String deviceName;
  final String location;
  final String consumption;
  final String cost;

  HistoryDetailItemModel({
    required this.id,
    required this.icon,
    required this.deviceName,
    required this.location,
    required this.consumption,
    required this.cost,
  });

  /// Factory constructor untuk membuat instance dari JSON map.
  factory HistoryDetailItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailItemModel(
      id: json['_id'] ?? json['id'] ?? '', // Backend sering menggunakan _id
      deviceName: json['deviceName'] ?? 'Unknown Device',
      location: json['location'] ?? 'Unassigned',
      consumption: json['consumption'] ?? '0 kWh',
      cost: json['cost'] ?? 'Rp 0',
      // Ikon untuk UI, bisa di-map berdasarkan deviceName atau default
      icon: _mapDeviceNameToIcon(json['deviceName']),
    );
  }

  /// Method untuk mengubah instance menjadi JSON map.
  /// Berguna saat mengirim data ke backend (misalnya saat POST).
  Map<String, dynamic> toJson() {
    return {
      'deviceName': deviceName,
      'location': location,
      'consumption': consumption,
      'cost': cost,
    };
  }

  /// Helper untuk memetakan nama perangkat ke ikon tertentu
  static IconData _mapDeviceNameToIcon(String? deviceName) {
    // Anda bisa tambahkan logika di sini
    // if (deviceName?.toLowerCase().contains('ac') ?? false) return Icons.ac_unit;
    return Icons.electrical_services_outlined;
  }
}
