import 'package:flutter/cupertino.dart';
import 'package:haber_uygulamasi/services/newsservice.dart';
import 'article_viewmodel.dart';

enum Status { initial, loading, loaded }

class ArticleListViewModel extends ChangeNotifier {
  ArticleViewModel viewModel = ArticleViewModel('', []);
  Status status = Status.initial;

  ArticleListViewModel() {
    getNews("", "");
  }

  Future<void> getNews(String category, String searchq) async {
    status = Status.loading;
    notifyListeners();
    viewModel.articles = await NewsServices().fetchNews(category, searchq);
    status = Status.loaded;
    notifyListeners();
  }
}
