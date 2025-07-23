import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wattsense/data/repositories/auth_repository.dart';
import '../../../../domain/models/auth_user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState.unknown());

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthState.unauthenticated());
  }

  void userLoggedIn(AuthUserModel user) {
    print('--- PENGGUNA BERHASIL LOGIN: ${user.username} ---');
    emit(AuthState.authenticated(user));
  }

  Future<void> logout() async {
    print('--- PROSES LOGOUT DIMULAI ---');
    await _authRepository.logout(); // Panggil method asli jika tersedia
    emit(const AuthState.unauthenticated());
    print('--- STATUS BERUBAH MENJADI UNAUTHENTICATED ---');
  }
}
