import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AssetCardWidget extends StatelessWidget {
  final Map<String, dynamic> asset;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onReportIssue;
  final VoidCallback? onScheduleMaintenance;
  final VoidCallback? onTransferAsset;

  const AssetCardWidget({
    Key? key,
    required this.asset,
    this.onTap,
    this.onViewDetails,
    this.onReportIssue,
    this.onScheduleMaintenance,
    this.onTransferAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = asset['status'] ?? 'unknown';
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key('asset_${asset['id']}'),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right actions
          _showQuickActions(context);
        } else {
          // Swipe left actions
          if (onTransferAsset != null) onTransferAsset!();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.cardShadow,
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                _buildAssetThumbnail(context),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildAssetInfo(context, isDarkMode),
                ),
                _buildStatusIndicator(context, status, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetThumbnail(BuildContext context) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: asset['image'] != null && asset['image'].isNotEmpty
            ? CustomImageWidget(
                imageUrl: asset['image'],
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              )
            : Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: CustomIconWidget(
                  iconName: _getAssetIcon(asset['category'] ?? 'computer'),
                  color: Theme.of(context).colorScheme.primary,
                  size: 6.w,
                ),
              ),
      ),
    );
  }

  Widget _buildAssetInfo(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          asset['name'] ?? 'Unknown Asset',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          'ID: ${asset['id'] ?? 'N/A'}',
          style: AppTheme.dataTextStyle(
            isLight: !isDarkMode,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Expanded(
              child: Text(
                asset['location'] ?? 'Unknown Location',
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'Last: ${asset['lastMaintenance'] ?? 'Never'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(
      BuildContext context, String status, bool isDarkMode) {
    final Color statusColor =
        AppTheme.getStatusColor(status, isLight: !isDarkMode);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'more_horiz' : 'swap_horiz',
                color: isLeft
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.tertiary,
                size: 6.w,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft ? 'Actions' : 'Transfer',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isLeft
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildActionTile(
              context,
              icon: 'visibility',
              title: 'View Details',
              onTap: () {
                Navigator.pop(context);
                if (onViewDetails != null) onViewDetails!();
              },
            ),
            _buildActionTile(
              context,
              icon: 'report_problem',
              title: 'Report Issue',
              onTap: () {
                Navigator.pop(context);
                if (onReportIssue != null) onReportIssue!();
              },
            ),
            _buildActionTile(
              context,
              icon: 'schedule',
              title: 'Schedule Maintenance',
              onTap: () {
                Navigator.pop(context);
                if (onScheduleMaintenance != null) onScheduleMaintenance!();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              asset['name'] ?? 'Asset Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildActionTile(
              context,
              icon: 'edit',
              title: 'Edit Asset',
              onTap: () => Navigator.pop(context),
            ),
            _buildActionTile(
              context,
              icon: 'history',
              title: 'View History',
              onTap: () => Navigator.pop(context),
            ),
            _buildActionTile(
              context,
              icon: 'qr_code',
              title: 'Show QR Code',
              onTap: () => Navigator.pop(context),
            ),
            _buildActionTile(
              context,
              icon: 'share',
              title: 'Share Asset',
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: Theme.of(context).colorScheme.primary,
        size: 5.w,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _getAssetIcon(String category) {
    switch (category.toLowerCase()) {
      case 'laptop':
      case 'computer':
        return 'laptop';
      case 'monitor':
      case 'display':
        return 'monitor';
      case 'printer':
        return 'print';
      case 'phone':
      case 'mobile':
        return 'phone_android';
      case 'tablet':
        return 'tablet';
      case 'server':
        return 'dns';
      case 'network':
      case 'router':
        return 'router';
      case 'camera':
        return 'camera_alt';
      case 'projector':
        return 'videocam';
      default:
        return 'devices';
    }
  }
}
