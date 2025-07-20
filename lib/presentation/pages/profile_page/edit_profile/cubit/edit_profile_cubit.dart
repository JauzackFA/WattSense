import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../data/repositories/profile_repository.dart'; // Ganti dengan path Anda

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository _profileRepository;

  EditProfileCubit(this._profileRepository) : super(const EditProfileState());

  /// Memperbarui data profil pengguna.
  Future<void> updateUserProfile(
      {required String field, required String value}) async {
    // Emit state loading agar UI bisa menampilkan progress indicator
    emit(state.copyWith(status: EditProfileStatus.loading));
    try {
      // Panggil repository untuk mengirim data ke server
      await _profileRepository.updateProfile({field: value});

      // Jika berhasil, emit state success
      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (e) {
      // Jika gagal, emit state failure dengan pesan error
      emit(state.copyWith(
          status: EditProfileStatus.failure, errorMessage: e.toString()));
    }
  }
}
