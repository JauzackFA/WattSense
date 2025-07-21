import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Pastikan path ke repository Anda sudah benar
// import '../../../../data/repositories/auth_repository.dart';
// Model pengguna, sesuaikan jika perlu
import '../../../../domain/models/auth_user_model.dart';

part 'auth_state.dart';

// --- Mock Classes for Compilation ---
// Ini adalah kelas tiruan agar kode bisa berjalan tanpa error.
// Ganti dengan implementasi asli di proyek Anda.

class AuthRepository {
  Future<void> logout() async {
    // Simulasi proses logout di server
    print("Menghapus token dari server...");
    await Future.delayed(const Duration(milliseconds: 500));
    print("Token berhasil dihapus.");
  }
}

// --- End of Mock Classes ---

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState.unknown());

  /// Mengecek status otentikasi saat aplikasi dimulai.
  /// Di aplikasi nyata, ini akan memeriksa token yang tersimpan.
  Future<void> checkAuthStatus() async {
    // Untuk simulasi, kita anggap pengguna selalu belum login saat aplikasi dimulai.
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthState.unauthenticated());
  }

  /// Dipanggil oleh LoginCubit setelah login berhasil.
  void userLoggedIn(AuthUserModel user) {
    // Di aplikasi nyata, Anda akan menyimpan token di sini.
    print('--- PENGGUNA BERHASIL LOGIN: ${user.username} ---');
    emit(AuthState.authenticated(user));
  }

  /// Menjalankan proses logout.
  Future<void> logout() async {
    print('--- PROSES LOGOUT DIMULAI ---');
    // Di aplikasi nyata, Anda akan memanggil repository untuk menghapus token di server.
    // await _authRepository.logout();
    emit(const AuthState.unauthenticated());
    print('--- STATUS BERUBAH MENJADI UNAUTHENTICATED ---');
  }
}
