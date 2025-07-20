import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../../data/repositories/auth_repository.dart';

part 'login_state.dart';

/// Cubit untuk mengelola state dan logika bisnis dari LoginPage.
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  /// Menjalankan proses login dengan email dan password.
  Future<void> login(String email, String password) async {
    // Emit state 'loading' agar UI bisa menampilkan progress indicator.
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authRepository.login(
        email: email,
        password: password,
      );
      // Jika berhasil, emit state 'success' dengan data pengguna.
      emit(
        state.copyWith(
          status: LoginStatus.success,
          user: user,
        ),
      );
    } catch (e) {
      // Jika gagal, emit state 'failure' dengan pesan error.
      emit(state.copyWith(
          status: LoginStatus.failure, errorMessage: e.toString()));
    }
  }
}
