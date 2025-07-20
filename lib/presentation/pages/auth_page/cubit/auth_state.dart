part of 'auth_cubit.dart';

// Enum untuk status otentikasi
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUserModel? user; // Model pengguna yang login

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
  });

  // State saat aplikasi baru dimulai, belum tahu statusnya
  const AuthState.unknown() : this._();

  // State saat pengguna berhasil login
  const AuthState.authenticated(AuthUserModel user)
      : this._(status: AuthStatus.authenticated, user: user);

  // State saat pengguna belum login atau sudah logout
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}
