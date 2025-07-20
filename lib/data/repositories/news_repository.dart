import '../../domain/models/news_item_model.dart';

/// Repository untuk mengelola data yang terkait dengan berita dan tips.
class NewsRepository {
  /// Mensimulasikan pengambilan daftar berita dari API.
  Future<List<NewsItemModel>> getNews() async {
    // Memberi jeda untuk mensimulasikan panggilan jaringan.
    await Future.delayed(const Duration(milliseconds: 1200));

    // Mengembalikan daftar data dummy.
    // Di aplikasi nyata, ini akan menjadi hasil panggilan HTTP.
    return _dummyNews;
  }

  // Data dummy privat untuk simulasi.
  static final List<NewsItemModel> _dummyNews = [
    NewsItemModel(
      id: '1',
      title: 'Penaikan Harga Listrik Semakin Tinggi pada Tahun 2025',
      snippet:
          'Pada tahun 2025, harga listrik diprediksi akan mengalami kenaikan yang signifikan, mempengaruhi biaya hidup masyarakat secara luas. Kenaikan ini dipicu oleh berbagai faktor, termasuk peningkatan harga bahan bakar.',
      date: '31 Januari 2025',
      imageUrl: 'assets/images/news_icon.png', // Path ke aset lokal
    ),
    NewsItemModel(
      id: '2',
      title: '5 Tips Cerdas Menghemat Listrik di Rumah Tangga',
      snippet:
          'Dengan beberapa langkah sederhana, Anda bisa mengurangi tagihan listrik bulanan secara signifikan. Mulai dari memilih peralatan yang efisien hingga mengubah kebiasaan sehari-hari.',
      date: '30 Januari 2025',
      imageUrl: 'assets/images/news_icon.png',
    ),
    NewsItemModel(
      id: '3',
      title: 'Pemerintah Luncurkan Insentif untuk Pengguna Energi Terbarukan',
      snippet:
          'Sebagai upaya mendorong transisi energi, pemerintah memberikan berbagai insentif bagi masyarakat yang beralih menggunakan sumber energi terbarukan seperti panel surya.',
      date: '28 Januari 2025',
      imageUrl: 'assets/images/news_icon.png',
    ),
    NewsItemModel(
      id: '4',
      title: 'Waspada! Bahaya Korsleting Listrik di Musim Hujan',
      snippet:
          'Musim hujan meningkatkan risiko korsleting listrik. Kenali penyebabnya dan lakukan langkah-langkah pencegahan untuk menjaga keselamatan keluarga Anda.',
      date: '25 Januari 2025',
      imageUrl: 'assets/images/news_icon.png',
    ),
  ];
}
