import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompanyLogoWidget extends StatelessWidget {
  const CompanyLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 20.h,
      constraints: BoxConstraints(
        maxWidth: 280,
        maxHeight: 160,
        minWidth: 200,
        minHeight: 120,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 25.w,
            height: 12.h,
            constraints: BoxConstraints(
              maxWidth: 120,
              maxHeight: 120,
              minWidth: 80,
              minHeight: 80,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'business',
                    color: Colors.white,
                    size: 8.w > 40 ? 40 : 8.w,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'KM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 4.w > 20 ? 20 : 4.w,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'KMAsset E-Ticketing',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontSize: 5.w > 24 ? 24 : 5.w,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Enterprise Asset Management',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 3.w > 14 ? 14 : 3.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
