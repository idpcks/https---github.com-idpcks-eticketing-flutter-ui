import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AssetInfoCards extends StatelessWidget {
  final Map<String, dynamic> assetData;

  const AssetInfoCards({
    Key? key,
    required this.assetData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Asset ID and Category Row
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Asset ID',
                  value: assetData['assetId']?.toString() ?? 'N/A',
                  icon: 'qr_code',
                  context: context,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildInfoCard(
                  title: 'Category',
                  value: assetData['category']?.toString() ?? 'N/A',
                  icon: 'category',
                  context: context,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Location and Assigned User Row
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Location',
                  value: assetData['location']?.toString() ?? 'N/A',
                  icon: 'location_on',
                  context: context,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildInfoCard(
                  title: 'Assigned To',
                  value: assetData['assignedUser']?.toString() ?? 'Unassigned',
                  icon: 'person',
                  context: context,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Purchase Date and Status Row
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  title: 'Purchase Date',
                  value: assetData['purchaseDate']?.toString() ?? 'N/A',
                  icon: 'calendar_today',
                  context: context,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatusCard(
                  title: 'Status',
                  status: assetData['status']?.toString() ?? 'Unknown',
                  context: context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required String icon,
    required BuildContext context,
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
                size: 18,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String status,
    required BuildContext context,
  }) {
    final statusColor = AppTheme.getStatusColor(status, isLight: true);

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
                iconName: 'info',
                size: 18,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
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
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
