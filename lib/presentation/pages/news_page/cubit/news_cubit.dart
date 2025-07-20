import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/repositories/news_repository.dart';
import '../../../../domain/models/news_item_model.dart';

part 'news_state.dart';

/// Cubit untuk mengelola state dan logika bisnis dari NewsPage.
class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository;

  NewsCubit(this._newsRepository) : super(const NewsState());

  /// Mengambil daftar berita dari repository.
  Future<void> fetchNews() async {
    emit(state.copyWith(status: NewsStatus.loading));
    try {
      final newsList = await _newsRepository.getNews();
      emit(state.copyWith(
        status: NewsStatus.success,
        news: newsList,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: NewsStatus.failure, errorMessage: e.toString()));
    }
  }
}
