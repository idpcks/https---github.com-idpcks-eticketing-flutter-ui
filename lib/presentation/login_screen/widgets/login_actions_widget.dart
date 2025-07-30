import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginActionsWidget extends StatelessWidget {
  final VoidCallback onForgotPassword;
  final VoidCallback onContactSupport;

  const LoginActionsWidget({
    Key? key,
    required this.onForgotPassword,
    required this.onContactSupport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Forgot Password Link
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPassword,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              minimumSize: Size(0, 6.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot Password?',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 3.5.w > 14 ? 14 : 3.5.w,
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ),

        SizedBox(height: 6.h),

        // Contact IT Support Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'support_agent',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w > 24 ? 24 : 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need Help?',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontSize: 3.5.w > 14 ? 14 : 3.5.w,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Contact IT Support for account issues or password reset assistance',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontSize: 3.w > 12 ? 12 : 3.w,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Contact Support Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onContactSupport,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w > 18 ? 18 : 4.w,
                  ),
                  label: Text(
                    'Contact IT Support',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontSize: 3.5.w > 14 ? 14 : 3.5.w,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Security Notice
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.tertiaryContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 4.w > 20 ? 20 : 4.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Your connection is secured with enterprise-grade encryption',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 3.w > 12 ? 12 : 3.w,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
