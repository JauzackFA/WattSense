/// Model untuk merepresentasikan data profil pengguna.
class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String imageUrl;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
  });

  /// Factory constructor untuk membuat instance dari data JSON.
  /// Ini akan digunakan saat integrasi dengan back-end.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      imageUrl: json['image_url'],
    );
  }
}
