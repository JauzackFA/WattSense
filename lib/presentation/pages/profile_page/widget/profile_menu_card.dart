import 'package:flutter/material.dart';
import '../edit_profile/edit_profile_page.dart';
import '../help_center/help_center_page.dart';
import '../usage_configuration/usage_configuration_page.dart';
import 'profile_menu_item.dart';

// --- 1. IMPORT HALAMAN-HALAMAN TUJUAN ---
// Sesuaikan path ini dengan struktur folder Anda

/// Kartu yang berisi daftar menu pada halaman profil.
class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'Name, Phone Number, Email',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.settings_power,
            title: 'Usage Configuration',
            subtitle: 'Edit your preferences, data, and more',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UsageConfigurationPage()),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help and Services',
            subtitle: 'FAQ, Customer Service',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpCenterPage()),
              );
            },
            hideDivider: true,
          ),
        ],
      ),
    );
  }
}
