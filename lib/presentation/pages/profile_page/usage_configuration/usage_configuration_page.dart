import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/configuration_cubit.dart';

class UsageConfigurationPage extends StatelessWidget {
  const UsageConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'Usage Configuration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: BlocConsumer<ConfigurationCubit, ConfigurationState>(
          listener: (context, state) {
            if (state.status == ConfigurationStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.errorMessage ?? 'Update failed')));
            } else if (state.status == ConfigurationStatus.success) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                  content: Text('Limit updated successfully!'),
                  backgroundColor: Colors.green,
                ));
            }
          },
          builder: (context, state) {
            // Tampilkan loading indicator saat data pertama kali dimuat
            if (state.status == ConfigurationStatus.initial ||
                (state.status == ConfigurationStatus.loading &&
                    state.configuration.monthlyCostLimit == 0)) {
              return const Center(child: CircularProgressIndicator());
            }

            final config = state.configuration;
            final bool isUpdating = state.status == ConfigurationStatus.loading;

            return AbsorbPointer(
              absorbing: isUpdating,
              child: Opacity(
                opacity: isUpdating ? 0.5 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildConfigRow(
                        context,
                        label: 'Monthly Cost Limit',
                        value: NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(config.monthlyCostLimit),
                        onEdit: () =>
                            _showEditDialog(context, config.monthlyCostLimit),
                      ),
                      const SizedBox(height: 24),
                      _buildConfigRow(
                        context,
                        label: 'Monthly Usage Limit',
                        value:
                            '${config.monthlyUsageLimit.toStringAsFixed(0)} kWh',
                        onEdit: () {
                          // TODO: Implementasi dialog untuk edit usage limit
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Menampilkan dialog untuk mengedit batas biaya bulanan.
  void _showEditDialog(BuildContext context, double currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue.toInt().toString());
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Edit Monthly Cost Limit'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              prefixText: 'Rp ',
              hintText: '1000000',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newLimit = double.tryParse(controller.text);
                if (newLimit != null) {
                  // Memanggil metode cubit untuk update
                  context.read<ConfigurationCubit>().updateCostLimit(newLimit);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  /// Helper widget untuk membuat satu baris konfigurasi.
  Widget _buildConfigRow(BuildContext context,
      {required String label,
      required String value,
      required VoidCallback onEdit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
              onPressed: onEdit,
            ),
          ],
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }
}
