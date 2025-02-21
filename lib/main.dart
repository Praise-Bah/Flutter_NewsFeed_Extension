import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/news_article.dart';
import 'services/news_service.dart';
import 'widgets/category_filter.dart';
import 'widgets/news_card.dart';
import 'screens/settings_page.dart';

void main() {
  runApp(const NewsFeedApp());
}

class NewsFeedApp extends StatelessWidget {
  const NewsFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Feed',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NewsFeedPage(),
    );
  }
}

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> articles = [];
  bool isLoading = true;
  String selectedCategory = 'all';
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadDefaultCategory();
    _setupAutoRefresh();
  }

  Future<void> _loadDefaultCategory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategory = prefs.getString('defaultCategory') ?? 'all';
    });
    fetchNews();
  }

  void _setupAutoRefresh() {
    Future.delayed(const Duration(minutes: 5), () {
      if (mounted) {
        fetchNews();
        _setupAutoRefresh();
      }
    });
  }

  Future<void> fetchNews() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final fetchedArticles = await _newsService.fetchNews(
        category: selectedCategory == 'all' ? null : selectedCategory,
      );

      setState(() {
        articles = fetchedArticles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchNews,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CategoryFilter(
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              setState(() {
                selectedCategory = category;
              });
              fetchNews();
            },
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load news'),
            ElevatedButton(
              onPressed: fetchNews,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (articles.isEmpty) {
      return const Center(
        child: Text('No news articles available'),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchNews,
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return NewsCard(article: articles[index]);
        },
      ),
    );
  }
}