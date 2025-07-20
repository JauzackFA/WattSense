import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wattsense/presentation/pages/auth_page/login/login_page.dart';
import 'package:wattsense/presentation/widgets/main_navigation.dart';
import 'cubit/auth_cubit.dart';

/// Widget yang membungkus aplikasi dan secara deklaratif menampilkan halaman
/// yang benar berdasarkan status otentikasi dari [AuthCubit].
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // DIUBAH: Menggunakan BlocBuilder untuk secara langsung membangun UI
    // yang sesuai dengan state, bukan menggunakan listener untuk navigasi.
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Jika pengguna sudah terotentikasi, tampilkan halaman utama.
        if (state.status == AuthStatus.authenticated) {
          return const MainNavigation();
        }
        // Jika pengguna tidak terotentikasi, tampilkan halaman login.
        if (state.status == AuthStatus.unauthenticated) {
          return const LoginPage();
        }
        // Jika status belum diketahui (saat aplikasi baru dimulai),
        // tampilkan layar loading.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
