import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/article.dart';
import 'package:flutter_application_1/models/news_state.dart';
import 'package:flutter_application_1/services/user_data_service.dart';
import 'package:flutter_application_1/screens/posts_scroll_screen.dart';
import 'package:flutter_application_1/services/req_service.dart';
import 'package:flutter_application_1/widgets/article_card.dart';
import 'package:flutter_application_1/widgets/newspaper_wrapper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

class NewsScrollScreen extends StatefulWidget {
  const NewsScrollScreen({super.key});

  @override
  NewsScrollScreenState createState() => NewsScrollScreenState();
}

class NewsScrollScreenState extends State<NewsScrollScreen> {
  late Future<List<dynamic>> _newsFuture;
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();

    _newsFuture = _initAndLoadNews();
  }

  Future<List<dynamic>> _initAndLoadNews() async {
    await initializeDateFormatting('es_ES', null);
    return await _loadNews();
  }

  void _toggleExpanded(int index) {
    setState(() {
      _expandedIndex = (_expandedIndex == index) ? -1 : index;
    });
  }

  Future<List<dynamic>> _loadNews() async {
    final userData = await getUserData();
    final countryCode = userData['countryCode'];
    final articles = await fetchTopHeadlines(context, countryCode);
    newsState.news = articles;
    return articles;
  }

  Future<void> _refreshNews() async {
    final newArticles = await _loadNews();
    setState(() {
      newsState.news = newArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: SizedBox(
          height: 100,
          width: double.infinity,
          child: Center(
              child: Text(
            'NOTICIAS',
            style: const TextStyle(
              fontFamily: 'Chomsky', // Usa tu fuente personalizada
              fontSize: 50,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
            textAlign: TextAlign.center,
          )),
        ),
        automaticallyImplyLeading: false,
      ),
      body: NewspaperWrapper(
        backcolor: Colors.white,
        screen: const PostsScrollScreen(),
        previusScreen: context,
        turnDirection: TurnDirection.leftToRight,
        child: newsState.news.isNotEmpty
            ? RefreshIndicator(
                onRefresh: _refreshNews,
                child: ListView.builder(
                  itemCount: newsState.news.length,
                  itemBuilder: (context, index) {
                    final article = newsState.news[index];
                    return ArticleCard(
                      article: Article(
                        title: article['title'],
                        snippet: article['snippet'],
                        link: article['link'],
                        imgUrl: article['photo_url'],
                        datetime: article['published_datetime_utc'],
                        source: article['source_name'],
                      ),
                      isExpanded: _expandedIndex == index,
                      onTap: () => _toggleExpanded(index),
                    );
                  },
                ),
              )
            : FutureBuilder<List<dynamic>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    newsState.news = snapshot.data!;

                    return RefreshIndicator(
                      onRefresh: _refreshNews,
                      child: newsState.news.isEmpty
                          ? SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'No hay noticias disponibles',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  IconButton(
                                    onPressed: _refreshNews,
                                    icon: const Icon(Icons.refresh),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: newsState.news.length,
                              itemBuilder: (context, index) {
                                final article = newsState.news[index];
                                return ArticleCard(
                                  article: Article(
                                    title: article['title'],
                                    snippet: article['snippet'],
                                    link: article['link'],
                                    imgUrl: article['photo_url'],
                                    datetime: article['published_datetime_utc'],
                                    source: article['source_name'],
                                  ),
                                  isExpanded: _expandedIndex == index,
                                  onTap: () => _toggleExpanded(index),
                                );
                              },
                            ),
                    );
                  } else {
                    return const Center(
                        child: Text('No hay noticias disponibles'));
                  }
                },
              ),
      ),
    );
  }
}
