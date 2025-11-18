import 'package:flutter/material.dart';
import 'package:news_app/presentation/screens/everything_section.dart';
import 'package:provider/provider.dart';

import '../../logic/filter_provider.dart';
import '../../logic/tab_index_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'top_headlines_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final filterOptions = context.read<FilterProvider>();
    _searchController.text = filterOptions.searchQuery;
  }

  void _showFilterSheet(BuildContext context) {
    final filterOptions = context.read<FilterProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FilterBottomSheet(
        isEverything: _tabController.index == 0,
        sortBy: filterOptions.selectedSortOption,
        selectedCountry: filterOptions.selectedCountry,
        selectedCategory: filterOptions.selectedCategory,
        fromDate: filterOptions.fromDate,
        toDate: filterOptions.toDate,
        onApply: (sortBy, country, category, fromDate, toDate) {
          filterOptions.applyFilters(sortOption: sortBy, country: country, category: category, from: fromDate, to: toDate);
          // _loadArticles();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = context.watch<FilterProvider>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'News API',
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () => _showFilterSheet(context),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search articles by keyword...',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                filterOptions.updateSearchQuery(null);
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => filterOptions.updateSearchQuery(_searchController.text.isNotEmpty ? _searchController.text : null),
                  ),
                ),

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  indicatorWeight: 2,
                  onTap: (int index) {
                    context.read<TabIndexProvider>().updateIndex(index);
                  },
                  tabs: const [
                    Tab(text: 'Everything'),
                    Tab(text: 'Top Headlines'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Articles List
            Expanded(
              child: TabBarView(controller: _tabController, children: [EverythingSection(), TopHeadlinesSection()]),
            ),

            // API Info Footer
            Container(
              padding: const EdgeInsets.all(12),
              color: const Color(0xFFDEEBFF),
              child: Text(
                'API Endpoint: /v2/${context.read<TabIndexProvider>().currentIndex == 0 ? 'everything' : 'top-headlines'} • Sort: ${filterOptions.selectedSortOption.label}${filterOptions.selectedCategory != null ? ' • Category: ${filterOptions.selectedCategory!.name}' : ''}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF1E40AF)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
