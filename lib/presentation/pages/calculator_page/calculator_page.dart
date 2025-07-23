import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/models/history_detail_item_model.dart';
import '../../../service/calculator_service.dart';
import '../../widgets/custom_form_field.dart';
import '../../widgets/primary_action_button.dart';
import '../../widgets/priority_dropdown.dart';
import '../history_page/cubit/history_cubit.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _powerController = TextEditingController();
  final _durationController = TextEditingController();

  String? _selectedPriority = 'Medium';
  final List<String> _priorities = ['High', 'Medium', 'Low'];

  String? _selectedRoom = 'Living Room';
  final List<String> _rooms = [
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
    'Garage',
    'Laundry Room',
    'Others'
  ];

  String _costEstimate = 'Rp 0';

  @override
  void initState() {
    super.initState();
    _powerController.addListener(_updateCost);
    _durationController.addListener(_updateCost);
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _powerController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _updateCost() {
    final power = double.tryParse(_powerController.text) ?? 0;
    final duration = double.tryParse(_durationController.text) ?? 0;
    final cost = CalculatorService.calculateMonthlyCost(
        power: power, duration: duration);
    setState(() {
      _costEstimate = CalculatorService.formatToRupiah(cost);
    });
  }

  /// Fungsi untuk menyimpan perangkat baru ke dalam state global.
  void _saveDevice() {
    if (!_formKey.currentState!.validate()) return;

    // Buat instance dari Uuid
    const uuid = Uuid();

    // Ambil semua nilai dari form.
    final String deviceName = _deviceNameController.text;
    final double power = double.parse(_powerController.text);
    final double duration = double.parse(_durationController.text);
    final String location = _selectedRoom!;

    // Hitung biaya dan konsumsi final.
    final double monthlyCost = CalculatorService.calculateMonthlyCost(
        power: power, duration: duration);
    final double monthlyKwh =
        CalculatorService.calculateMonthlyKwh(power: power, duration: duration);

    // Buat objek HistoryDetailItemModel baru.
    final newDevice = HistoryDetailItemModel(
      // 2. Buat ID unik sementara menggunakan uuid
      id: uuid.v4(),

      icon: Icons.electrical_services_outlined,
      deviceName: deviceName,
      location: location,
      consumption: '${monthlyKwh.toStringAsFixed(1)} kWh',
      cost: CalculatorService.formatToRupiah(monthlyCost),
    );

    print('✅ [UI] Data perangkat yang akan dikirim: ${newDevice.toString()}');

    // Panggil metode di Cubit untuk menambahkan item baru.
    context.read<HistoryCubit>().addDeviceToHistory(newDevice);

    // Beri feedback ke pengguna.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deviceName berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset semua field.
    _formKey.currentState?.reset();
    _deviceNameController.clear();
    _powerController.clear();
    _durationController.clear();
    setState(() {
      _selectedPriority = 'Medium';
      _selectedRoom = 'Living Room';
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Atur backgroundColor Scaffold agar sama dengan AppBar
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'Device Calculator',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0BC2E7),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      // 2. Bungkus Form dengan Container untuk styling
      body: Container(
        // 3. Tambahkan BoxDecoration
        decoration: BoxDecoration(
          // 4. Atur warna Container menjadi putih agar kontras
          color: Colors.grey[100],
          // 5. Atur borderRadius hanya untuk sisi atas
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        // Clip child agar mengikuti bentuk borderRadius
        clipBehavior: Clip.hardEdge,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... sisa widget Anda tidak perlu diubah ...
                CustomFormField(
                  controller: _deviceNameController,
                  labelText: 'Device Name',
                  hintText: 'e.g., Air Conditioner',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Device name cannot be empty'
                      : null,
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  controller: _powerController,
                  labelText: 'Power (watt)',
                  hintText: 'e.g., 750',
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Power cannot be empty'
                      : null,
                ),
                const SizedBox(height: 24),
                CustomFormField(
                  controller: _durationController,
                  labelText: 'Duration of Use / Day (Hour)',
                  hintText: 'e.g., 8',
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Duration cannot be empty'
                      : null,
                ),
                const SizedBox(height: 24),

                PriorityDropdown(
                  labelText: 'Room',
                  selectedValue: _selectedRoom,
                  items: _rooms,
                  backgroundColor: Colors.white,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRoom = newValue;
                    });
                  },
                ),
                const SizedBox(height: 24),

                PriorityDropdown(
                  labelText: 'Priority',
                  selectedValue: _selectedPriority,
                  items: _priorities,
                  backgroundColor: Colors.white,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Electricity Cost Estimate / Month',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        _costEstimate,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                PrimaryActionButton(
                  text: 'Save Device',
                  onPressed: _saveDevice,
                  backgroundColor: const Color(0xFF0BC2E7),
                  foregroundColor: Colors.white,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
