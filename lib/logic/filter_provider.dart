import 'package:flutter/material.dart';
import 'package:news_app/core/utils/constants.dart';
import 'package:news_app/core/utils/date_utils.dart' as app_date_utils;

class FilterProvider extends ChangeNotifier {
  SortOption _selectedSortOption = SortOption.publishedAt;
  Country _selectedCountry = Country.us;
  Category? _selectedCategory;
  String _searchQuery = 'bitcoin';
  DateTime? _fromDate;
  DateTime? _toDate;
  final int _page = 1;

  int get page => _page;
  SortOption get selectedSortOption => _selectedSortOption;
  Country get selectedCountry => _selectedCountry;
  Category? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;

  Map<String, dynamic> get currentEveryThingFilters {
    return {
      'sortBy': _selectedSortOption.name,
      'q': _searchQuery,
      if (_fromDate != null) 'from': app_date_utils.DateUtils.toApiDateFormat(_fromDate!),
      if (_toDate != null) 'to': app_date_utils.DateUtils.toApiDateFormat(_toDate!),
      'language': 'en',
      'pageSize': 20,
      'page': _page,
    };
  }

  Map<String, dynamic> get currentTopHeadlinesFilters {
    return {
      'country': _selectedCountry.code,
      if (_selectedCategory != null) 'category': _selectedCategory!.name,
      'q': _searchQuery,
      'pageSize': 20,
      'page': _page,
    };
  }

  void updateSortOption(SortOption option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void updateCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void updateCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearchQuery(String? query) {
    _searchQuery = query ?? 'all';
    notifyListeners();
  }

  void updateDateRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    notifyListeners();
  }

  void applyFilters({required SortOption sortOption, required Country country, Category? category, DateTime? from, DateTime? to}) {
    _selectedSortOption = sortOption;
    _selectedCountry = country;
    _selectedCategory = category;
    _fromDate = from;
    _toDate = to;
    notifyListeners();
  }
}
