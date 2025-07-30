import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/asset_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/skeleton_card_widget.dart';

class AssetList extends StatefulWidget {
  const AssetList({Key? key}) : super(key: key);

  @override
  State<AssetList> createState() => _AssetListState();
}

class _AssetListState extends State<AssetList> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};

  int _currentPage = 1;
  final int _itemsPerPage = 20;

  // Mock data for assets
  final List<Map<String, dynamic>> _allAssets = [
    {
      "id": "AST001",
      "name": "MacBook Pro 16\"",
      "category": "laptop",
      "location": "Office Floor 2",
      "status": "active",
      "assignment": "assigned",
      "lastMaintenance": "2025-07-15",
      "image":
          "https://images.pexels.com/photos/205421/pexels-photo-205421.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": "John Smith",
      "purchaseDate": "2024-01-15",
      "warrantyExpiry": "2027-01-15",
    },
    {
      "id": "AST002",
      "name": "Dell Monitor 27\"",
      "category": "monitor",
      "location": "Office Floor 1",
      "status": "active",
      "assignment": "assigned",
      "lastMaintenance": "2025-07-20",
      "image":
          "https://images.pexels.com/photos/777001/pexels-photo-777001.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": "Sarah Johnson",
      "purchaseDate": "2024-03-10",
      "warrantyExpiry": "2027-03-10",
    },
    {
      "id": "AST003",
      "name": "HP LaserJet Pro",
      "category": "printer",
      "location": "Office Floor 3",
      "status": "maintenance",
      "assignment": "unassigned",
      "lastMaintenance": "2025-07-25",
      "image":
          "https://images.pexels.com/photos/4226140/pexels-photo-4226140.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": null,
      "purchaseDate": "2023-11-20",
      "warrantyExpiry": "2026-11-20",
    },
    {
      "id": "AST004",
      "name": "iPhone 15 Pro",
      "category": "phone",
      "location": "Remote",
      "status": "active",
      "assignment": "assigned",
      "lastMaintenance": "2025-07-10",
      "image":
          "https://images.pexels.com/photos/699122/pexels-photo-699122.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": "Mike Wilson",
      "purchaseDate": "2024-09-22",
      "warrantyExpiry": "2025-09-22",
    },
    {
      "id": "AST005",
      "name": "Surface Pro 9",
      "category": "tablet",
      "location": "Office Floor 2",
      "status": "active",
      "assignment": "available",
      "lastMaintenance": "2025-07-18",
      "image":
          "https://images.pexels.com/photos/1334597/pexels-photo-1334597.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": null,
      "purchaseDate": "2024-05-15",
      "warrantyExpiry": "2026-05-15",
    },
    {
      "id": "AST006",
      "name": "Dell PowerEdge Server",
      "category": "server",
      "location": "Warehouse",
      "status": "active",
      "assignment": "assigned",
      "lastMaintenance": "2025-07-12",
      "image":
          "https://images.pexels.com/photos/325229/pexels-photo-325229.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": "IT Department",
      "purchaseDate": "2023-08-30",
      "warrantyExpiry": "2028-08-30",
    },
    {
      "id": "AST007",
      "name": "Cisco Router",
      "category": "network",
      "location": "Office Floor 1",
      "status": "active",
      "assignment": "assigned",
      "lastMaintenance": "2025-07-22",
      "image":
          "https://images.pexels.com/photos/159304/network-cable-ethernet-computer-159304.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": "Network Team",
      "purchaseDate": "2023-12-05",
      "warrantyExpiry": "2026-12-05",
    },
    {
      "id": "AST008",
      "name": "Canon DSLR Camera",
      "category": "camera",
      "location": "Office Floor 3",
      "status": "active",
      "assignment": "available",
      "lastMaintenance": "2025-07-14",
      "image":
          "https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": null,
      "purchaseDate": "2024-02-28",
      "warrantyExpiry": "2026-02-28",
    },
    {
      "id": "AST009",
      "name": "Epson Projector",
      "category": "projector",
      "location": "Office Floor 2",
      "status": "inactive",
      "assignment": "unassigned",
      "lastMaintenance": "2025-06-30",
      "image":
          "https://images.pexels.com/photos/2608517/pexels-photo-2608517.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": null,
      "purchaseDate": "2023-04-12",
      "warrantyExpiry": "2026-04-12",
    },
    {
      "id": "AST010",
      "name": "Gaming Desktop PC",
      "category": "desktop",
      "location": "Office Floor 1",
      "status": "active",
      "assignment": "assigned",
      "lastMaintenance": "2025-07-28",
      "image":
          "https://images.pexels.com/photos/2582937/pexels-photo-2582937.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "assignedTo": "Design Team",
      "purchaseDate": "2024-06-10",
      "warrantyExpiry": "2027-06-10",
    },
  ];

  List<Map<String, dynamic>> _filteredAssets = [];
  List<Map<String, dynamic>> _displayedAssets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _scrollController.addListener(_onScroll);
    _filteredAssets = List.from(_allAssets);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
      _currentPage = 1;
      _displayedAssets = _filteredAssets.take(_itemsPerPage).toList();
      _hasMoreData = _filteredAssets.length > _itemsPerPage;
    });
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex =
        (startIndex + _itemsPerPage).clamp(0, _filteredAssets.length);

    if (startIndex < _filteredAssets.length) {
      setState(() {
        _displayedAssets.addAll(_filteredAssets.sublist(startIndex, endIndex));
        _currentPage++;
        _hasMoreData = endIndex < _filteredAssets.length;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _hasMoreData = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _applyFilters();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredAssets = _allAssets.where((asset) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          final matchesSearch = (asset['name'] as String)
                  .toLowerCase()
                  .contains(searchLower) ||
              (asset['id'] as String).toLowerCase().contains(searchLower) ||
              (asset['location'] as String).toLowerCase().contains(searchLower);
          if (!matchesSearch) return false;
        }

        // Category filter
        if (_activeFilters['category'] != null &&
            _activeFilters['category'] != 'All') {
          if (asset['category'] != _activeFilters['category'].toLowerCase())
            return false;
        }

        // Location filter
        if (_activeFilters['location'] != null &&
            _activeFilters['location'] != 'All') {
          if (asset['location'] != _activeFilters['location']) return false;
        }

        // Status filter
        if (_activeFilters['status'] != null &&
            _activeFilters['status'] != 'All') {
          if (asset['status'] != _activeFilters['status'].toLowerCase())
            return false;
        }

        // Assignment filter
        if (_activeFilters['assignment'] != null &&
            _activeFilters['assignment'] != 'All') {
          if (asset['assignment'] != _activeFilters['assignment'].toLowerCase())
            return false;
        }

        return true;
      }).toList();

      _currentPage = 1;
      _displayedAssets = _filteredAssets.take(_itemsPerPage).toList();
      _hasMoreData = _filteredAssets.length > _itemsPerPage;
    });
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _applyFilters();
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
    });
    _applyFilters();
  }

  List<Widget> _buildFilterChips() {
    List<Widget> chips = [];

    _activeFilters.forEach((key, value) {
      if (value != null && value != 'All' && value != 'Any time') {
        chips.add(
          FilterChipWidget(
            label: '$key: $value',
            count: _getFilterCount(key, value),
            isSelected: true,
            onTap: () {},
            onRemove: () => _removeFilter(key),
          ),
        );
      }
    });

    return chips;
  }

  int _getFilterCount(String filterKey, String filterValue) {
    return _allAssets.where((asset) {
      switch (filterKey) {
        case 'category':
          return asset['category'] == filterValue.toLowerCase();
        case 'location':
          return asset['location'] == filterValue;
        case 'status':
          return asset['status'] == filterValue.toLowerCase();
        case 'assignment':
          return asset['assignment'] == filterValue.toLowerCase();
        default:
          return false;
      }
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabBar(context),
            _buildSearchAndFilters(context),
            if (_buildFilterChips().isNotEmpty) _buildActiveFilters(context),
            Expanded(
              child: _buildAssetList(context),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: Theme.of(context).colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Asset Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomIconWidget(
              iconName: 'notifications',
              color: Theme.of(context).colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'Dashboard'),
          Tab(text: 'Assets'),
          Tab(text: 'Tickets'),
          Tab(text: 'Reports'),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: SearchBarWidget(
        controller: _searchController,
        onChanged: _onSearchChanged,
        onQRScan: () => Navigator.pushNamed(context, '/qr-scanner'),
        onFilter: () => _showFilterBottomSheet(context),
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    return Container(
      height: 6.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _buildFilterChips(),
      ),
    );
  }

  Widget _buildAssetList(BuildContext context) {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) => SkeletonCardWidget(),
      );
    }

    if (_filteredAssets.isEmpty) {
      return EmptyStateWidget(
        title: 'No Assets Found',
        subtitle: _searchQuery.isNotEmpty
            ? 'No assets match your search criteria. Try adjusting your filters or search terms.'
            : 'Start by scanning QR codes or adding assets manually to build your inventory.',
        actionText: 'Scan to Add Asset',
        onAction: () => Navigator.pushNamed(context, '/qr-scanner'),
        illustration:
            'https://images.pexels.com/photos/4226140/pexels-photo-4226140.jpeg?auto=compress&cs=tinysrgb&w=400',
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _displayedAssets.length + (_isLoadingMore ? 3 : 0),
        itemBuilder: (context, index) {
          if (index >= _displayedAssets.length) {
            return SkeletonCardWidget();
          }

          final asset = _displayedAssets[index];
          return AssetCardWidget(
            asset: asset,
            onTap: () =>
                Navigator.pushNamed(context, '/asset-detail', arguments: asset),
            onViewDetails: () =>
                Navigator.pushNamed(context, '/asset-detail', arguments: asset),
            onReportIssue: () => _showReportIssueDialog(context, asset),
            onScheduleMaintenance: () =>
                _showScheduleMaintenanceDialog(context, asset),
            onTransferAsset: () => _showTransferAssetDialog(context, asset),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddAssetDialog(context),
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 5.w,
      ),
      label: Text('Add Asset'),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: _onFilterChanged,
      ),
    );
  }

  void _showReportIssueDialog(
      BuildContext context, Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Issue'),
        content: Text('Report an issue for ${asset['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Issue reported for ${asset['name']}')),
              );
            },
            child: Text('Report'),
          ),
        ],
      ),
    );
  }

  void _showScheduleMaintenanceDialog(
      BuildContext context, Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Maintenance'),
        content: Text('Schedule maintenance for ${asset['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Maintenance scheduled for ${asset['name']}')),
              );
            },
            child: Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _showTransferAssetDialog(
      BuildContext context, Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transfer Asset'),
        content: Text('Transfer ${asset['name']} to another user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${asset['name']} transfer initiated')),
              );
            },
            child: Text('Transfer'),
          ),
        ],
      ),
    );
  }

  void _showAddAssetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Asset'),
        content: Text('Choose how to add a new asset to the inventory.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/qr-scanner');
            },
            child: Text('Scan QR Code'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Manual asset entry form opened')),
              );
            },
            child: Text('Manual Entry'),
          ),
        ],
      ),
    );
  }
}
