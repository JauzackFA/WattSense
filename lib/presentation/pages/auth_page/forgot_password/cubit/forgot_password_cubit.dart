import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wattsense/data/repositories/auth_repository.dart';

part 'forgot_password_state.dart';

/// Cubit untuk mengelola state dan logika bisnis dari ForgotPasswordPage.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
      : super(const ForgotPasswordState());

  /// Menjalankan proses pengiriman link reset password.
  Future<void> sendResetLink(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await _authRepository.forgotPassword(email: email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
