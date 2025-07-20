import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'Help and Service',
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
          color: Colors.grey[100], // Warna yang Anda inginkan untuk body
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // --- Header ---
            const Text(
              'Hello Mickey,',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'How we can help you?',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // --- Search Bar ---
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter your question',
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // --- Frequently Asked Questions ---
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              'Bagaimana cara aplikasi ini menghitung estimasi biaya?',
            ),
            _buildFaqItem(
              'Apakah perhitungan biayanya 100% akurat?',
            ),
            _buildFaqItem(
              'Apa fungsi dari "Priority" saat menambahkan perangkat?',
            ),
            const SizedBox(height: 20),

            // --- Contact Options ---
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildContactOption(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chat now',
                    onTap: () {
                      // TODO: Implementasi live chat
                    },
                  ),
                  _buildContactOption(
                    icon: Icons.phone_outlined,
                    title: 'Telephone',
                    onTap: () {
                      // TODO: Implementasi panggilan telepon
                    },
                  ),
                  _buildContactOption(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    onTap: () {
                      // TODO: Implementasi kirim email
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget untuk satu item FAQ
  Widget _buildFaqItem(String question) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(question, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // TODO: Navigasi ke detail FAQ
        },
      ),
    );
  }

  /// Helper widget untuk satu opsi kontak
  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
