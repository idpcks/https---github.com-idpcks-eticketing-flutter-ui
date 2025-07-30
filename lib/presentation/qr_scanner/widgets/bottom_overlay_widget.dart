import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomOverlayWidget extends StatelessWidget {
  final VoidCallback onManualEntry;
  final VoidCallback onRecentScans;
  final List<Map<String, dynamic>> recentScans;

  const BottomOverlayWidget({
    super.key,
    required this.onManualEntry,
    required this.onRecentScans,
    required this.recentScans,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Manual entry button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton.icon(
                onPressed: onManualEntry,
                icon: CustomIconWidget(
                  iconName: 'keyboard',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Manual Entry',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Recent scans section
            if (recentScans.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Scans',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: onRecentScans,
                    child: Text(
                      'View All',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              SizedBox(
                height: 8.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentScans.length > 3 ? 3 : recentScans.length,
                  separatorBuilder: (context, index) => SizedBox(width: 3.w),
                  itemBuilder: (context, index) {
                    final scan = recentScans[index];
                    return _buildRecentScanItem(scan);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecentScanItem(Map<String, dynamic> scan) {
    return Container(
      width: 20.w,
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: _getAssetIcon(scan['type'] as String),
            color: Colors.white,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            scan['assetId'] as String,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
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
      default:
        return 'devices';
    }
  }
}
