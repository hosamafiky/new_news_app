import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:news_app/utils/constants.dart';

import '../models/article.dart';
import '../services/error_model.dart';
import '../services/news_api_service.dart';
import '../utils/date_utils.dart' as app_date_utils;
import '../widgets/article_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final NewsApiService _apiService = NewsApiService();

  List<Article> _articles = [];
  bool _isLoading = false;
  int _totalResults = 0;

  // Filter values
  String _sortBy = 'publishedAt';
  Country _selectedCountry = Country.us;
  Category? _selectedCategory;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadArticles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadArticles();
    }
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
    });

    Either<ErrorModel, NewsResponse> response;

    if (_tabController.index == 0) {
      // Everything endpoint
      response = await _apiService.getEverything(
        query: _searchController.text.isEmpty ? null : _searchController.text,
        sortBy: _sortBy,
        from: _fromDate != null ? app_date_utils.DateUtils.toApiDateFormat(_fromDate!) : null,
        to: _toDate != null ? app_date_utils.DateUtils.toApiDateFormat(_toDate!) : null,
      );
    } else {
      // Top Headlines endpoint
      response = await _apiService.getTopHeadlines(
        country: _selectedCountry,
        category: _selectedCategory,
        query: _searchController.text.isEmpty ? null : _searchController.text,
      );
    }

    response.fold(
      (error) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading articles: ${error.message}')));
      },
      (response) {
        setState(() {
          _articles = response.articles;
          _totalResults = response.totalResults;
          _isLoading = false;
        });
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FilterBottomSheet(
        isEverything: _tabController.index == 0,
        sortBy: _sortBy,
        selectedCountry: _selectedCountry,
        selectedCategory: _selectedCategory,
        fromDate: _fromDate,
        toDate: _toDate,
        onApply: (sortBy, country, category, fromDate, toDate) {
          setState(() {
            _sortBy = sortBy;
            _selectedCountry = country;
            _selectedCategory = category;
            _fromDate = fromDate;
            _toDate = toDate;
          });
          _loadArticles();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: _showFilterSheet,
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
                              _loadArticles();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _loadArticles(),
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                indicatorWeight: 2,
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
          // Results Info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Results: ${_totalResults.toString()}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                if (_searchController.text.isNotEmpty)
                  Text('Searching for "${_searchController.text}"', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          // Articles List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadArticles,
                    child: _articles.isEmpty
                        ? const Center(child: Text('No articles found'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _articles.length,
                            itemBuilder: (context, index) {
                              return ArticleCard(article: _articles[index]);
                            },
                          ),
                  ),
          ),

          // API Info Footer
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFDEEBFF),
            child: Text(
              'API Endpoint: /v2/${_tabController.index == 0 ? 'everything' : 'top-headlines'} • Sort: $_sortBy${_selectedCategory != null ? ' • Category: $_selectedCategory' : ''}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF1E40AF)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
