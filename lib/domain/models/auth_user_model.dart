/// Model untuk merepresentasikan data pengguna dan token setelah login.
class AuthUserModel {
  final String id;
  final String name;
  final String email;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Factory constructor untuk membuat instance dari data JSON.
  /// Ini akan digunakan saat integrasi dengan back-end.
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
    );
  }
}
