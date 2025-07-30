import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AssetDetailTabs extends StatefulWidget {
  final Map<String, dynamic> assetData;

  const AssetDetailTabs({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  @override
  State<AssetDetailTabs> createState() => _AssetDetailTabsState();
}

class _AssetDetailTabsState extends State<AssetDetailTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: Column(
        children: [
          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'History'),
                Tab(text: 'Maintenance'),
                Tab(text: 'Documents'),
              ],
              labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              dividerColor: Colors.transparent,
            ),
          ),
          SizedBox(height: 2.h),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTab(),
                _buildHistoryTab(),
                _buildMaintenanceTab(),
                _buildDocumentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    final specifications =
        widget.assetData['specifications'] as Map<String, dynamic>? ?? {};
    final warranty =
        widget.assetData['warranty'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specifications Card
          _buildSectionCard(
            title: 'Specifications',
            icon: 'settings',
            child: Column(
              children: specifications.entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          entry.key,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          entry.value?.toString() ?? 'N/A',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 2.h),

          // Warranty Information Card
          _buildSectionCard(
            title: 'Warranty Information',
            icon: 'verified_user',
            child: Column(
              children: [
                _buildDetailRow(
                    'Start Date', warranty['startDate']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    'End Date', warranty['endDate']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    'Provider', warranty['provider']?.toString() ?? 'N/A'),
                _buildDetailRow(
                    'Coverage', warranty['coverage']?.toString() ?? 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final history = (widget.assetData['history'] as List<dynamic>?) ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: history.map<Widget>((event) {
          final eventMap = event as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: _buildHistoryItem(
              title: eventMap['title']?.toString() ?? 'Unknown Event',
              description: eventMap['description']?.toString() ?? '',
              date: eventMap['date']?.toString() ?? '',
              type: eventMap['type']?.toString() ?? 'info',
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    final maintenance =
        (widget.assetData['maintenance'] as List<dynamic>?) ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: maintenance.map<Widget>((item) {
          final maintenanceMap = item as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: _buildMaintenanceItem(
              title: maintenanceMap['title']?.toString() ?? 'Maintenance Task',
              description: maintenanceMap['description']?.toString() ?? '',
              dueDate: maintenanceMap['dueDate']?.toString() ?? '',
              status: maintenanceMap['status']?.toString() ?? 'pending',
              priority: maintenanceMap['priority']?.toString() ?? 'medium',
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final documents = (widget.assetData['documents'] as List<dynamic>?) ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: documents.map<Widget>((doc) {
          final docMap = doc as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: _buildDocumentItem(
              name: docMap['name']?.toString() ?? 'Document',
              type: docMap['type']?.toString() ?? 'pdf',
              size: docMap['size']?.toString() ?? '0 KB',
              uploadDate: docMap['uploadDate']?.toString() ?? '',
              url: docMap['url']?.toString() ?? '',
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String icon,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                size: 20,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String description,
    required String date,
    required String type,
  }) {
    final typeColor = AppTheme.getStatusColor(type, isLight: true);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                date,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem({
    required String title,
    required String description,
    required String dueDate,
    required String status,
    required String priority,
  }) {
    final statusColor = AppTheme.getStatusColor(status, isLight: true);
    final priorityColor = priority == 'high'
        ? AppTheme.lightTheme.colorScheme.error
        : priority == 'medium'
            ? AppTheme.lightTheme.colorScheme.tertiary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: priorityColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  priority.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Due: $dueDate',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentItem({
    required String name,
    required String type,
    required String size,
    required String uploadDate,
    required String url,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getDocumentIcon(type),
              size: 24,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '$size • $uploadDate',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle document download/preview
            },
            icon: CustomIconWidget(
              iconName: 'download',
              size: 20,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getDocumentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'picture_as_pdf';
      case 'doc':
      case 'docx':
        return 'description';
      case 'xls':
      case 'xlsx':
        return 'table_chart';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      default:
        return 'insert_drive_file';
    }
  }
}
