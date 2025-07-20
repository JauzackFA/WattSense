import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wattsense/data/repositories/auth_repository.dart';

part 'signup_state.dart';

/// Cubit untuk mengelola state dan logika bisnis dari SignUpPage.
class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(const SignUpState());

  /// Menjalankan proses pendaftaran dengan email dan password.
  // Di dalam file SignUpCubit.dart

  Future<void> signUp({required String email, required String password}) async {
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      await _authRepository.signUp(email: email, password: password);
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      // TAMBAHKAN PRINT DI SINI UNTUK MELIHAT ERROR ASLINYA
      print('--- SIGN UP GAGAL ---');
      print('Tipe Error: ${e.runtimeType}');
      print('Detail Error: $e');

      emit(state.copyWith(
          status: SignUpStatus.failure, errorMessage: e.toString()));
    }
  }
}
