import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _categories = [
    'All',
    'Laptop',
    'Desktop',
    'Monitor',
    'Printer',
    'Phone',
    'Tablet',
    'Server',
    'Network',
    'Other'
  ];

  final List<String> _locations = [
    'All',
    'Office Floor 1',
    'Office Floor 2',
    'Office Floor 3',
    'Warehouse',
    'Remote',
    'Maintenance'
  ];

  final List<String> _statuses = [
    'All',
    'Active',
    'Inactive',
    'Maintenance',
    'Retired',
    'Lost'
  ];

  final List<String> _assignments = [
    'All',
    'Assigned',
    'Unassigned',
    'Available',
    'Reserved'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    context,
                    title: 'Category',
                    options: _categories,
                    selectedValue: _filters['category'] ?? 'All',
                    onChanged: (value) =>
                        setState(() => _filters['category'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    context,
                    title: 'Location',
                    options: _locations,
                    selectedValue: _filters['location'] ?? 'All',
                    onChanged: (value) =>
                        setState(() => _filters['location'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    context,
                    title: 'Status',
                    options: _statuses,
                    selectedValue: _filters['status'] ?? 'All',
                    onChanged: (value) =>
                        setState(() => _filters['status'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    context,
                    title: 'Assignment',
                    options: _assignments,
                    selectedValue: _filters['assignment'] ?? 'All',
                    onChanged: (value) =>
                        setState(() => _filters['assignment'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildDateRangeFilter(context),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Assets',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onChanged,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        selectedValue,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      children: options.map((option) {
        final bool isSelected = option == selectedValue;
        return ListTile(
          title: Text(
            option,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
          ),
          trailing: isSelected
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                )
              : null,
          onTap: () => onChanged(option),
        );
      }).toList(),
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Last Maintenance',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        _filters['dateRange'] ?? 'Any time',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      children: [
        ListTile(
          title: Text('Last 7 days'),
          trailing: (_filters['dateRange'] == 'Last 7 days')
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                )
              : null,
          onTap: () => setState(() => _filters['dateRange'] = 'Last 7 days'),
        ),
        ListTile(
          title: Text('Last 30 days'),
          trailing: (_filters['dateRange'] == 'Last 30 days')
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                )
              : null,
          onTap: () => setState(() => _filters['dateRange'] = 'Last 30 days'),
        ),
        ListTile(
          title: Text('Last 90 days'),
          trailing: (_filters['dateRange'] == 'Last 90 days')
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                )
              : null,
          onTap: () => setState(() => _filters['dateRange'] = 'Last 90 days'),
        ),
        ListTile(
          title: Text('Any time'),
          trailing: (_filters['dateRange'] == null ||
                  _filters['dateRange'] == 'Any time')
              ? CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                )
              : null,
          onTap: () => setState(() => _filters['dateRange'] = 'Any time'),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                  });
                },
                child: Text('Clear All'),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFiltersChanged(_filters);
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
