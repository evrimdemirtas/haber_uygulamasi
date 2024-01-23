import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haber_uygulamasi/models/articles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodel/article_list_viewmodel.dart';
import '../models/category.dart';
import '../services/newsservice.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class Category {
  String key;
  Category(this.key);
}

class _HomePageState extends State<HomePage> {
  String? searchWord;
  bool isSearching = false;
  TextEditingController seachController = TextEditingController();

  List<Category> categories = [
    Category('general'),
    Category('technology'),
    Category('sports'),
    Category(
      'entertainment',
    ),
    Category('business'),
    Category('science'),
    Category(
      'health',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);

    return Scaffold(
      appBar: isSearching
          ? searchAppBar()
          : AppBar(
              backgroundColor: Colors.red,
              title: const Text('News'),
              actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      icon: const Icon(Icons.search)),
                ]),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getCategoriesTab(vm),
            ),
          ),
          getWidgetByStatus(vm)
        ],
      ),
    );
  }

  searchAppBar() {
    return AppBar(
      backgroundColor: Colors.red,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              isSearching = false;
              searchWord = null;
              seachController.text = "";
            });
          }),
      title: TextField(
        controller: seachController,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            )),
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                searchWord = seachController.text;
              });
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  List<GestureDetector> getCategoriesTab(ArticleListViewModel vm) {
    List<GestureDetector> list = [];
    for (int i = 0; i < categories.length; i++) {
      list.add(GestureDetector(
        onTap: () => vm.getNews(categories[i].key),
        child: Container(
            margin:
                EdgeInsets.only(left: 4.0, top: 10.0, right: 4.0, bottom: 2.0),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5.0,
                shadowColor: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    categories[i].key.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ))),
      ));
    }
    return list;
  }

  Widget getWidgetByStatus(ArticleListViewModel vm) {
    switch (vm.status.index) {
      case 2:
        return Expanded(
            child: ListView.builder(
                itemCount: vm.viewModel.articles.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Image.network(vm.viewModel.articles[index].urlToImage ??
                            'https://rutecprojekt.de/assets/images/2/News_AdobeStock_116225048_neu-de28855b.jpg'),
                        ListTile(
                          title: Text(
                            vm.viewModel.articles[index].title ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              vm.viewModel.articles[index].description ?? ''),
                        ),
                        ButtonBar(
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                await launchUrl(Uri.parse(
                                    vm.viewModel.articles[index].url ?? ''));
                              },
                              child: const Text(
                                'Detail',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
