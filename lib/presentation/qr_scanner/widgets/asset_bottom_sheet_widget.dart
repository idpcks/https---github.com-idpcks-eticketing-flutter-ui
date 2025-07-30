import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AssetBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> assetData;
  final VoidCallback onViewDetails;
  final VoidCallback onReportIssue;
  final VoidCallback onUpdateStatus;
  final VoidCallback onClose;

  const AssetBottomSheetWidget({
    super.key,
    required this.assetData,
    required this.onViewDetails,
    required this.onReportIssue,
    required this.onUpdateStatus,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: 70.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.only(top: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Asset Details',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: AppTheme.lightTheme.colorScheme.outline,
            height: 1,
          ),
          // Asset information
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asset image and basic info
                  Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName:
                                _getAssetIcon(assetData['type'] as String),
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 32,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assetData['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'ID: ${assetData['assetId']}',
                              style: AppTheme.dataTextStyle(
                                  isLight: true, fontSize: 12.sp),
                            ),
                            SizedBox(height: 0.5.h),
                            _buildStatusChip(assetData['status'] as String),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  // Asset details
                  _buildDetailRow('Location', assetData['location'] as String),
                  _buildDetailRow(
                      'Department', assetData['department'] as String),
                  _buildDetailRow(
                      'Assigned To', assetData['assignedTo'] as String),
                  _buildDetailRow(
                      'Last Updated', assetData['lastUpdated'] as String),
                  if (assetData['description'] != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Description',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      assetData['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                  SizedBox(height: 3.h),
                  // Quick actions
                  Text(
                    'Quick Actions',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'View Details',
                          'visibility',
                          onViewDetails,
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildActionButton(
                          'Report Issue',
                          'report_problem',
                          onReportIssue,
                          AppTheme.lightTheme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: _buildActionButton(
                      'Update Status',
                      'update',
                      onUpdateStatus,
                      AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final Color statusColor = AppTheme.getStatusColor(status, isLight: true);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
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
    );
  }

  Widget _buildActionButton(
      String label, String iconName, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: iconName,
        color: Colors.white,
        size: 18,
      ),
      label: Text(
        label,
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _getAssetIcon(String type) {
    switch (type.toLowerCase()) {
      case 'laptop':
        return 'laptop';
      case 'desktop':
        return 'desktop_windows';
      case 'printer':
        return 'print';
      case 'monitor':
        return 'monitor';
      case 'phone':
        return 'phone_android';
      case 'tablet':
        return 'tablet';
      case 'server':
        return 'dns';
      default:
        return 'devices';
    }
  }
}
