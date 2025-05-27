import 'package:flutter/material.dart';
import 'package:flutter_application_1/classes/article.dart';
import 'package:flutter_application_1/classes/news_state.dart';
import 'package:flutter_application_1/data/user_data.dart';
import 'package:flutter_application_1/utilities/req_service.dart';
import 'package:flutter_application_1/widgets/article_widget.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> _newsFuture;
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    if (newsState.news.isEmpty) {
      _newsFuture = _initAndLoadNews();
    }
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
    final articles = await fetchTopHeadlines(countryCode);
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
        title: const Text('Noticias'),
      ),
      body: Expanded(
        child: newsState.news.isNotEmpty
            ? RefreshIndicator(
                onRefresh: _refreshNews,
                child: ListView.builder(
                  itemCount: newsState.news.length,
                  itemBuilder: (context, index) {
                    final article = newsState.news[index];
                    return ArticleWidget(
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
                      child: ListView.builder(
                        itemCount: newsState.news.length,
                        itemBuilder: (context, index) {
                          final article = newsState.news[index];
                          return ArticleWidget(
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
