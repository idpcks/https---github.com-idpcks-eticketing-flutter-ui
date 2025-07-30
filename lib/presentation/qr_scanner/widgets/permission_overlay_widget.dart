import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionOverlayWidget extends StatelessWidget {
  final VoidCallback onAllowCamera;
  final VoidCallback onCancel;

  const PermissionOverlayWidget({
    super.key,
    required this.onAllowCamera,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Camera icon
              Container(
                width: 30.w,
                height: 15.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 48,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              // Title
              Text(
                'Camera Access Required',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              // Description
              Text(
                'To scan QR codes and identify assets quickly, this app needs access to your device camera. This enables:',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              // Benefits list
              _buildBenefitItem(
                  'Instant asset identification', 'qr_code_scanner'),
              _buildBenefitItem('Faster ticket creation', 'speed'),
              _buildBenefitItem('Accurate asset tracking', 'track_changes'),
              _buildBenefitItem('Reduced manual entry errors', 'verified'),
              SizedBox(height: 4.h),
              // Allow camera button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton.icon(
                  onPressed: onAllowCamera,
                  icon: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Allow Camera Access',
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
              // Cancel button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: Text(
                    'Not Now',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              // Privacy note
              Text(
                'Your privacy is important. Camera access is only used for scanning and no images are stored.',
                style: AppTheme.lightTheme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, String iconName) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
