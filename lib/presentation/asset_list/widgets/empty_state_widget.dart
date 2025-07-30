import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback? onAction;
  final String? illustration;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.actionText,
    this.onAction,
    this.illustration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context),
            SizedBox(height: 4.h),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (onAction != null)
              ElevatedButton.icon(
                onPressed: onAction,
                icon: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Colors.white,
                  size: 5.w,
                ),
                label: Text(actionText),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: illustration != null && illustration!.isNotEmpty
            ? CustomImageWidget(
                imageUrl: illustration!,
                width: 30.w,
                height: 30.w,
                fit: BoxFit.contain,
              )
            : CustomIconWidget(
                iconName: 'inventory_2',
                color: Theme.of(context).colorScheme.primary,
                size: 20.w,
              ),
      ),
    );
  }
}
