import 'package:flutter/material.dart';

/// Widget dropdown yang reusable dan memiliki tampilan konsisten dengan TextFormField.
///
/// Widget ini menggunakan [DropdownButtonFormField] dan struktur label eksternal
/// untuk memastikan tampilan yang seragam dengan CustomFormField.
class PriorityDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final void Function(String?) onChanged;
  final String labelText;
  final Color? backgroundColor;

  const PriorityDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // DIUBAH: Menggunakan Column untuk menempatkan label di atas field,
    // persis seperti struktur pada CustomFormField.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Label yang gayanya disamakan dengan label di CustomFormField
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        // 2. DropdownFormField dengan InputDecoration yang disesuaikan
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            // labelText dihapus dari sini karena sudah ada di atas
            filled: true,
            // Warna latar belakang disamakan dengan CustomFormField (default putih)
            fillColor: backgroundColor ?? Colors.white,
            // Border disamakan
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            // Padding konten diatur agar tingginya sama dengan TextFormField
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
          ),
        ),
      ],
    );
  }
}
