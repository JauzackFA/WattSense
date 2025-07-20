/// Model untuk merepresentasikan satu artikel berita atau tips.
class NewsItemModel {
  final String id;
  final String title;
  final String snippet;
  final String date;
  final String imageUrl; // Bisa berupa path lokal atau URL dari server

  NewsItemModel({
    required this.id,
    required this.title,
    required this.snippet,
    required this.date,
    required this.imageUrl,
  });

  /// Factory constructor untuk membuat instance dari data JSON.
  /// Ini akan digunakan saat integrasi dengan back-end.
  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      id: json['id'],
      title: json['title'],
      snippet: json['snippet'],
      date: json['date'],
      imageUrl: json['image_url'],
    );
  }
}
