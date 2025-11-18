import 'package:flutter/material.dart';
import 'package:news_app/core/extensions/string.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;

class FilterBottomSheet extends StatefulWidget {
  final bool isEverything;
  final SortOption sortBy;
  final Country selectedCountry;
  final Category? selectedCategory;
  final DateTime? fromDate;
  final DateTime? toDate;
  final Function(SortOption, Country, Category?, DateTime?, DateTime?) onApply;

  const FilterBottomSheet({
    super.key,
    required this.isEverything,
    required this.sortBy,
    required this.selectedCountry,
    required this.selectedCategory,
    required this.fromDate,
    required this.toDate,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SortOption _sortBy;
  late Country _selectedCountry;
  Category? _selectedCategory;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _sortBy = widget.sortBy;
    _selectedCountry = widget.selectedCountry;
    _selectedCategory = widget.selectedCategory;
    _fromDate = widget.fromDate;
    _toDate = widget.toDate;
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? (_fromDate ?? DateTime.now()) : (_toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),

          const SizedBox(height: 20),

          // Sort By
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SortOption>(
                value: _sortBy,
                isExpanded: true,
                items: SortOption.values.map((option) {
                  return DropdownMenuItem<SortOption>(value: option, child: Text(option.label));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Country (for Top Headlines only)
          if (!widget.isEverything) ...[
            Row(
              children: const [
                Icon(Icons.public, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Country',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  value: _selectedCountry,
                  isExpanded: true,
                  items: Country.values.map((country) {
                    return DropdownMenuItem<Country>(value: country, child: Text(country.name));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category
            const Text(
              'Category',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Category.values.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? null : category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      border: Border.all(color: isSelected ? Colors.blue : Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category.name.capitalized,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Date Range (for Everything only)
          if (widget.isEverything) ...[
            Row(
              children: const [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Date Range',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _fromDate != null ? app_date_utils.DateUtils.formatDate(_fromDate!) : 'From',
                        style: TextStyle(fontSize: 14, color: _fromDate != null ? Colors.black87 : Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _toDate != null ? app_date_utils.DateUtils.formatDate(_toDate!) : 'To',
                        style: TextStyle(fontSize: 14, color: _toDate != null ? Colors.black87 : Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_sortBy, _selectedCountry, _selectedCategory, _fromDate, _toDate);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
