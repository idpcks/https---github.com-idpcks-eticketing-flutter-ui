import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AssetActionBar extends StatelessWidget {
  final VoidCallback onReportIssue;
  final VoidCallback onScheduleMaintenance;
  final VoidCallback onTransferAsset;

  const AssetActionBar({
    Key? key,
    required this.onReportIssue,
    required this.onScheduleMaintenance,
    required this.onTransferAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    onPressed: onReportIssue,
                    icon: 'report_problem',
                    label: 'Report Issue',
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildActionButton(
                    onPressed: onScheduleMaintenance,
                    icon: 'schedule',
                    label: 'Schedule',
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: _buildActionButton(
                onPressed: onTransferAsset,
                icon: 'swap_horiz',
                label: 'Transfer Asset',
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: CustomIconWidget(
        iconName: icon,
        size: 18,
        color: foregroundColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: backgroundColor.withValues(alpha: 0.3),
      ),
    );
  }
}
