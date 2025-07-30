import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/quick_action_widget.dart';
import './widgets/statistics_card_widget.dart';
import './widgets/user_header_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool _isOffline = false;
  bool _isRefreshing = false;
  int _currentBottomNavIndex = 0;
  late ScrollController _scrollController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _statisticsData = [
    {
      "title": "Total Assets",
      "value": "1,247",
      "subtitle": "+12 this month",
      "iconName": "inventory_2",
    },
    {
      "title": "Open Tickets",
      "value": "23",
      "subtitle": "5 high priority",
      "iconName": "confirmation_number",
    },
    {
      "title": "Pending Maintenance",
      "value": "8",
      "subtitle": "Due this week",
      "iconName": "build",
    },
    {
      "title": "Recent Activity",
      "value": "156",
      "subtitle": "Last 24 hours",
      "iconName": "trending_up",
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      "title": "Scan Asset",
      "iconName": "qr_code_scanner",
      "route": "/qr-scanner",
    },
    {
      "title": "Report Issue",
      "iconName": "report_problem",
      "route": "/create-ticket",
    },
    {
      "title": "Schedule Maintenance",
      "iconName": "schedule",
      "route": "/schedule-maintenance",
    },
    {
      "title": "View Reports",
      "iconName": "analytics",
      "route": "/reports",
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "type": "ticket",
      "title": "Printer Issue Resolved",
      "description":
          "HP LaserJet Pro M404n - Paper jam cleared and maintenance performed",
      "timestamp": "2 hours ago",
      "priority": "medium",
      "status": "resolved",
      "assetImage":
          "https://images.pexels.com/photos/4792728/pexels-photo-4792728.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 2,
      "type": "asset",
      "title": "New Asset Registered",
      "description": "Dell OptiPlex 7090 - Assigned to Marketing Department",
      "timestamp": "4 hours ago",
      "priority": "normal",
      "status": "active",
      "assetImage":
          "https://images.pexels.com/photos/2148217/pexels-photo-2148217.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 3,
      "type": "maintenance",
      "title": "Scheduled Maintenance",
      "description":
          "Server room cooling system - Monthly inspection completed",
      "timestamp": "6 hours ago",
      "priority": "high",
      "status": "completed",
    },
    {
      "id": 4,
      "type": "assignment",
      "title": "Asset Transfer",
      "description": "MacBook Pro 16\" - Transferred from IT to Design team",
      "timestamp": "8 hours ago",
      "priority": "normal",
      "status": "pending",
      "assetImage":
          "https://images.pexels.com/photos/18105/pexels-photo-18105.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
    {
      "id": 5,
      "type": "ticket",
      "title": "Network Connectivity Issue",
      "description":
          "Conference Room B - WiFi connection intermittent, investigating",
      "timestamp": "1 day ago",
      "priority": "high",
      "status": "in_progress",
    },
    {
      "id": 6,
      "type": "asset",
      "title": "Asset Depreciation Alert",
      "description": "iPhone 12 Pro - Reached 80% depreciation threshold",
      "timestamp": "1 day ago",
      "priority": "low",
      "status": "active",
      "assetImage":
          "https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg?auto=compress&cs=tinysrgb&w=400",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _checkConnectivity();
    _setupConnectivityListener();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  void _setupConnectivityListener() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleQuickAction(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleActivityTap(Map<String, dynamic> activity) {
    // Navigate to activity detail based on type
    switch (activity['type']) {
      case 'ticket':
        Navigator.pushNamed(context, '/ticket-detail',
            arguments: activity['id']);
        break;
      case 'asset':
        Navigator.pushNamed(context, '/asset-detail',
            arguments: activity['id']);
        break;
      case 'maintenance':
        Navigator.pushNamed(context, '/maintenance-detail',
            arguments: activity['id']);
        break;
      default:
        Navigator.pushNamed(context, '/activity-detail',
            arguments: activity['id']);
    }
  }

  void _handleActivityArchive(Map<String, dynamic> activity) {
    setState(() {
      _recentActivities.removeWhere((item) => item['id'] == activity['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Activity archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _recentActivities.add(activity);
            });
          },
        ),
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        Navigator.pushNamed(context, '/asset-list');
        break;
      case 2:
        Navigator.pushNamed(context, '/ticket-list');
        break;
      case 3:
        Navigator.pushNamed(context, '/qr-scanner');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _handleQuickReport() {
    Navigator.pushNamed(context, '/quick-report');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: UserHeaderWidget(
                  userName: "John Smith",
                  userRole: "IT Administrator",
                  notificationCount: 5,
                  onNotificationTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  onSearchTap: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ),

              // Offline indicator
              SliverToBoxAdapter(
                child: OfflineIndicatorWidget(
                  isOffline: _isOffline,
                  lastSyncTime: _isOffline ? "10 minutes ago" : null,
                ),
              ),

              // Statistics cards
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Text(
                        'Overview',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Wrap(
                        spacing: 3.w,
                        runSpacing: 2.h,
                        children: _statisticsData
                            .map((stat) => StatisticsCardWidget(
                                  title: stat['title'],
                                  value: stat['value'],
                                  subtitle: stat['subtitle'],
                                  iconName: stat['iconName'],
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick actions
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Text(
                        'Quick Actions',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _quickActions
                              .map((action) => Padding(
                                    padding: EdgeInsets.only(right: 3.w),
                                    child: QuickActionWidget(
                                      title: action['title'],
                                      iconName: action['iconName'],
                                      onTap: () =>
                                          _handleQuickAction(action['route']),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Recent activity
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activity',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/activity-list');
                            },
                            child: Text('View All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),

              // Activity list
              _recentActivities.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            CustomIconWidget(
                              iconName: 'inbox',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 15.w,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No recent activity',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Your recent activities will appear here',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3.h),
                            ElevatedButton(
                              onPressed: () =>
                                  _handleQuickAction('/qr-scanner'),
                              child: Text('Scan Asset'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final activity = _recentActivities[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: ActivityItemWidget(
                              activity: activity,
                              onTap: () => _handleActivityTap(activity),
                              onArchive: () => _handleActivityArchive(activity),
                            ),
                          );
                        },
                        childCount: _recentActivities.length,
                      ),
                    ),

              // Bottom padding for FAB
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentBottomNavIndex == 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'inventory_2',
                  color: _currentBottomNavIndex == 1
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 3.w,
                      minHeight: 3.w,
                    ),
                    child: Text(
                      '12',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onError,
                        fontWeight: FontWeight.w600,
                        fontSize: 7.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Assets',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'confirmation_number',
                  color: _currentBottomNavIndex == 2
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 3.w,
                      minHeight: 3.w,
                    ),
                    child: Text(
                      '5',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onError,
                        fontWeight: FontWeight.w600,
                        fontSize: 7.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: _currentBottomNavIndex == 3
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomNavIndex == 4
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),

      // Floating action button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _handleQuickReport,
          icon: CustomIconWidget(
            iconName: 'add',
            color:
                theme.floatingActionButtonTheme.foregroundColor ?? Colors.white,
            size: 6.w,
          ),
          label: Text(
            'Quick Report',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.floatingActionButtonTheme.foregroundColor ??
                  Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}