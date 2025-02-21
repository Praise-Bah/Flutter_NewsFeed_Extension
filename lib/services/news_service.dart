import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news_article.dart';
import 'package:flutter/foundation.dart';

class NewsService {
  static const String apiKey = 'pub_67301ce9b05dff7be2112a18049a96bab11c3';
  static const String apiUrl = 'https://newsdata.io/api/1/news';

  Future<List<NewsArticle>> fetchNews({String? category}) async {
    try {
      final queryParams = {
        'apikey': apiKey,
        'language': 'en',
        if (category != null && category != 'all') 'category': category,
      };

      final uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .map((article) => NewsArticle.fromJson(article))
            .toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');
      rethrow;
    }
  }
}
