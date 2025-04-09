import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/news_widget.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('Newspaper'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            30,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: NewsWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
