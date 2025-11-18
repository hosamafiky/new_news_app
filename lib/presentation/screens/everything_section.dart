import 'package:flutter/material.dart';
import 'package:news_app/core/di/dependency_injector.dart';
import 'package:news_app/logic/filter_provider.dart';
import 'package:news_app/presentation/widgets/article_card.dart';
import 'package:provider/provider.dart';

import '../../logic/articles_provider.dart';

class EverythingSection extends StatefulWidget {
  const EverythingSection({super.key});

  @override
  State<EverythingSection> createState() => _EverythingSectionState();
}

class _EverythingSectionState extends State<EverythingSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final filterOptions = context.watch<FilterProvider>();
    return ChangeNotifierProvider(
      create: (context) => di<ArticlesProvider>()..listenToFilterOptions(filterOptions, '/everything', filterOptions.currentEveryThingFilters),
      child: Consumer<ArticlesProvider>(
        builder: (context, articlesProvider, _) {
          return Scaffold(
            body: Column(
              children: [
                // Results Info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Results: ${articlesProvider.articlesCount}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      if (filterOptions.searchQuery.isNotEmpty)
                        Text('Searching for "${filterOptions.searchQuery}"', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: articlesProvider.result == null
                        ? Center(child: const CircularProgressIndicator.adaptive())
                        : articlesProvider.result!.fold(
                            (err) => Center(child: Text('Error: ${err.message}', textAlign: TextAlign.center)),
                            (articles) => ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: articles.length,
                              itemBuilder: (context, index) => ArticleCard(articles[index]),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
