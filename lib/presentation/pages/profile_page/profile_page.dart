import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wattsense/presentation/pages/auth_page/cubit/auth_cubit.dart';
import '../../widgets/primary_action_button.dart';
import 'widget/profile_info_header.dart';
import 'widget/profile_menu_card.dart';

/// Halaman profil pengguna yang telah direfaktor.
///
/// Halaman ini sekarang hanya bertugas menyusun widget-widget komponen
/// seperti header, kartu menu, dan tombol logout.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // --- Latar Belakang Biru di Bagian Atas ---
          // Container(
          //   height: 200,
          //   width: double.infinity,
          //   color: const Color(0xFF0BC2E7),
          // ),

          // --- Konten Utama ---
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 30),

                const ProfileInfoHeader(
                  backgroundImage: AssetImage('assets/images/dummy_photo.png'),
                  name: 'Mickey',
                ),

                const SizedBox(height: 30),

                // --- Bagian Menu ---
                const ProfileMenuCard(),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryActionButton(
                      text: 'Logout',
                      iconData: Icons.logout,
                      backgroundColor: Colors.red[100]!,
                      foregroundColor: Colors.red[700]!,
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk membangun tombol logout.
  /// Tetap di sini karena spesifik untuk halaman ini dan sederhana.
  // Widget _buildLogoutButton(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //     child: ElevatedButton(
  //       onPressed: () {
  //         // TODO: Implementasi logika logout
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.red[100],
  //         foregroundColor: Colors.red[700],
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //       ),
  //       child: const Text(
  //         'Logout',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
