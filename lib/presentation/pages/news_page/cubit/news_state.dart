part of 'news_cubit.dart';

/// Enum untuk status pengambilan data berita.
enum NewsStatus { initial, loading, success, failure }

/// State untuk NewsPage.
class NewsState extends Equatable {
  final NewsStatus status;
  final List<NewsItemModel> news;
  final String? errorMessage;

  const NewsState({
    this.status = NewsStatus.initial,
    this.news = const [],
    this.errorMessage,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<NewsItemModel>? news,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, news, errorMessage];
}
