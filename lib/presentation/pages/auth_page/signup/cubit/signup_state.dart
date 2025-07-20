part of 'signup_cubit.dart';

/// Enum untuk status proses pendaftaran.
enum SignUpStatus { initial, loading, success, failure }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.errorMessage,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
