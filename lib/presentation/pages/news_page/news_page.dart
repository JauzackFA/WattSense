import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/news_repository.dart';
import '../news_page/widget/news_card.dart';
import 'cubit/news_cubit.dart';

/// Entry point untuk halaman Berita, menyediakan NewsCubit.
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit(NewsRepository())..fetchNews(),
      child: const NewsView(),
    );
  }
}

/// Widget yang membangun UI untuk halaman Berita.
class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0BC2E7),
      appBar: AppBar(
        title: const Text(
          'News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            // State: Loading
            if (state.status == NewsStatus.loading ||
                state.status == NewsStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }

            // State: Gagal
            if (state.status == NewsStatus.failure) {
              return Center(
                  child: Text('Failed to load news: ${state.errorMessage}'));
            }

            // State: Sukses
            return ListView.separated(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              itemCount: state.news.length,
              itemBuilder: (context, index) {
                final newsItem = state.news[index];
                return NewsCard(newsItem: newsItem);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            );
          },
        ),
      ),
    );
  }
}
