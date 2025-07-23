class AuthUserModel {
  final String id;
  final String email;
  final String username;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.username,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;
    return AuthUserModel(
      id: userData['id'].toString(),
      email: userData['email'] ?? '',
      username: userData['username'] ?? userData['name'] ?? '',
    );
  }
}
