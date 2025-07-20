part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, loading, success, failure }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final String? errorMessage;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.errorMessage,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? errorMessage,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
