import 'dart:convert';
import 'package:haber_uygulamasi/models/articles.dart';
import 'package:http/http.dart' as http;
import '../models/news.dart';
import '../pages/home.dart';

class NewsServices {
  Future<List<Articles>> fetchNews(String category) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=b0f7dce996434b1396d5c0dea584d1b8';
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      News news = News.fromJson(result);
      return news.articles ?? [];
    }
    throw Exception('Bad Request');
  }
}
