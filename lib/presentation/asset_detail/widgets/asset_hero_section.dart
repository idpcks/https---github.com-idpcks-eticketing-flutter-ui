import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AssetHeroSection extends StatefulWidget {
  final Map<String, dynamic> assetData;
  final VoidCallback onCameraPressed;

  const AssetHeroSection({
    Key? key,
    required this.assetData,
    required this.onCameraPressed,
  }) : super(key: key);

  @override
  State<AssetHeroSection> createState() => _AssetHeroSectionState();
}

class _AssetHeroSectionState extends State<AssetHeroSection> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = (widget.assetData['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Container(
      height: 35.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Image Gallery
          images.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 35.h,
                      child: CustomImageWidget(
                        imageUrl: images[index],
                        width: double.infinity,
                        height: 35.h,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
              : Container(
                  width: double.infinity,
                  height: 35.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'image',
                        size: 48,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No images available',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

          // Image Indicators
          if (images.length > 1)
            Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    width: _currentImageIndex == index ? 3.w : 2.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                ),
              ),
            ),

          // Floating Camera Button
          Positioned(
            bottom: 2.h,
            right: 4.w,
            child: FloatingActionButton(
              onPressed: widget.onCameraPressed,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              mini: true,
              child: CustomIconWidget(
                iconName: 'camera_alt',
                size: 20,
                color: Colors.white,
              ),
            ),
          ),

          // Gradient Overlay for better text readability
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
