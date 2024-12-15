import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';

class NewsRepository {
  /// Fetch news headlines for a specific news channel.
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String source) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$source&apiKey=7f089d98af924c99aa8442d442a729e5';

    try {
      final response = await http.get(Uri.parse(url));

      // Check for a successful response
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Ensure body contains expected data
        if (body != null && body['articles'] != null) {
          return NewsChannelHeadlinesModel.fromJson(body);
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error: $e");
      }
      throw Exception("Network error: $e");
    }
  }

  /// Fetch news articles based on category.
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final String url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=7f089d98af924c99aa8442d442a729e5';

    try {
      final response = await http.get(Uri.parse(url));

      // Check for a successful response
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Ensure body contains expected data
        if (body != null && body['articles'] != null) {
          return CategoriesNewsModel.fromJson(body);
        } else {
          throw Exception("Invalid data format");
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Error: $e");
      }
      throw Exception("Network error: $e");
    }
  }
}
