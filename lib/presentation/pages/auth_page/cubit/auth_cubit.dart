import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/repositories/auth_repository.dart'; // Sesuaikan path

part 'auth_state.dart';

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
    emit(AuthState.authenticated(user));
  }

  /// Menjalankan proses logout.
  Future<void> logout() async {
    // Di aplikasi nyata, Anda akan memanggil repository untuk menghapus token di server.
    // await _authRepository.logout();
    print('--- LOGOUT METHOD CALLED ---');
    emit(const AuthState.unauthenticated());
  }
}
