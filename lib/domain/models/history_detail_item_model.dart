import 'package:flutter/material.dart';

class HistoryDetailItemModel {
  final IconData icon;
  final String deviceName;
  final String location;
  final String? consumption;
  final String cost;

  HistoryDetailItemModel({
    required this.icon,
    required this.deviceName,
    required this.location,
    this.consumption,
    required this.cost,
  });
}
