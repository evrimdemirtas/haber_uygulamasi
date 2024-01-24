import 'dart:convert';
import 'package:haber_uygulamasi/models/articles.dart';
import 'package:http/http.dart' as http;
import '../models/news.dart';
import '../pages/home.dart';

class NewsServices {
  Future<List<Articles>> fetchNews(String category, String searchq) async {
    String url =
        'https://newsapi.org/v2/top-headlines?q=$searchq&country=us&category=$category&apiKey=4a6accef1a3348a1a6e8bec8f53c25e5';
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
