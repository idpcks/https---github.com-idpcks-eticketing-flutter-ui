import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onFlashToggle;
  final bool isFlashOn;
  final bool isWeb;

  const CameraOverlayWidget({
    super.key,
    required this.onClose,
    required this.onFlashToggle,
    required this.isFlashOn,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            // Top overlay with close and flash buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: onClose,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Flash toggle button (only show on mobile)
                if (!isWeb)
                  Container(
                    width: 12.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: onFlashToggle,
                      icon: CustomIconWidget(
                        iconName: isFlashOn ? 'flash_on' : 'flash_off',
                        color: isFlashOn
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            // Scanning reticle in center
            _buildScanningReticle(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningReticle() {
    return Container(
      width: 60.w,
      height: 30.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Corner indicators
          Positioned(
            top: -2,
            left: -2,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            left: -2,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          // Center scanning line
          Center(
            child: Container(
              width: 50.w,
              height: 2,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
