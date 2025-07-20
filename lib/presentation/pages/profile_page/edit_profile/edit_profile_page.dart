import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repositories/profile_repository.dart'; // Ganti dengan path Anda
import 'cubit/edit_profile_cubit.dart';

/// Halaman untuk mengedit profil pengguna, terintegrasi dengan Cubit.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyediakan EditProfileCubit ke widget tree di bawahnya.
    return BlocProvider(
      create: (context) => EditProfileCubit(ProfileRepository()),
      child: const EditProfileView(),
    );
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        // Listener untuk aksi one-time seperti menampilkan SnackBar atau navigasi
        listener: (context, state) {
          if (state.status == EditProfileStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green));
            // TODO: Panggil cubit profil utama untuk refresh data
            // context.read<ProfileCubit>().fetchProfile();
          } else if (state.status == EditProfileStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.errorMessage ?? 'Update failed'),
                  backgroundColor: Colors.red));
          }
        },
        // Builder untuk membangun UI berdasarkan state
        builder: (context, state) {
          final bool isLoading = state.status == EditProfileStatus.loading;

          return AbsorbPointer(
            // Menonaktifkan interaksi saat sedang loading
            absorbing: isLoading,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isLoading ? Colors.grey[200] : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    children: [
                      _buildProfileOptionRow(
                        context,
                        title: 'Photo',
                        valueWidget: const CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              AssetImage('assets/images/dummy_photo.png'),
                        ),
                        onTap: () {/* TODO: Implementasi ganti foto */},
                      ),
                      _buildProfileOptionRow(
                        context,
                        title: 'Name',
                        valueWidget: const Text('Mickey',
                            style: TextStyle(color: Colors.grey)),
                        onTap: () => _showEditDialog(context, 'Name', 'name'),
                      ),
                      _buildProfileOptionRow(
                        context,
                        title: 'Phone Number',
                        valueWidget: const Text('081******321',
                            style: TextStyle(color: Colors.grey)),
                        onTap: () => _showEditDialog(
                            context, 'Phone Number', 'phone_number'),
                      ),
                      _buildProfileOptionRow(
                        context,
                        title: 'Email',
                        valueWidget: const Text('wattsense01@gmail.com',
                            style: TextStyle(color: Colors.grey)),
                        onTap: () => _showEditDialog(context, 'Email', 'email'),
                      ),
                    ],
                  ),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Menampilkan dialog untuk mengedit field profil.
  void _showEditDialog(BuildContext context, String title, String fieldKey) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter new $title'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                // Panggil metode cubit untuk update
                context.read<EditProfileCubit>().updateUserProfile(
                      field: fieldKey,
                      value: controller.text,
                    );
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileOptionRow(
    BuildContext context, {
    required String title,
    required Widget valueWidget,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          valueWidget,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
