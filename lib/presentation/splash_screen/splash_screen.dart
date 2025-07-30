import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/security_badge_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingText = 'Initializing...';
  bool _showSecurityBadge = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setSystemUIOverlay();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Check authentication
      await _updateLoadingText('Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 800));

      // Step 2: Load user permissions
      await _updateLoadingText('Loading permissions...');
      await Future.delayed(const Duration(milliseconds: 600));

      // Step 3: Sync asset database
      await _updateLoadingText('Syncing asset database...');
      await Future.delayed(const Duration(milliseconds: 700));

      // Step 4: Prepare QR scanner
      await _updateLoadingText('Preparing QR scanner...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 5: Show security badge
      setState(() {
        _showSecurityBadge = true;
      });

      await _updateLoadingText('Finalizing setup...');
      await Future.delayed(const Duration(milliseconds: 600));

      // Navigate based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors
      await _handleInitializationError();
    }
  }

  Future<void> _updateLoadingText(String text) async {
    if (mounted) {
      setState(() {
        _loadingText = text;
      });
    }
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    // Simulate authentication check
    final bool isAuthenticated = await _checkAuthenticationStatus();
    final bool isFirstTime = await _checkFirstTimeUser();

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (isFirstTime) {
      // For new enterprise users, could navigate to onboarding
      Navigator.pushReplacementNamed(context, '/login-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  Future<bool> _checkAuthenticationStatus() async {
    // Simulate checking stored authentication tokens
    await Future.delayed(const Duration(milliseconds: 200));
    return false; // For demo, always return false to show login
  }

  Future<bool> _checkFirstTimeUser() async {
    // Simulate checking if user has completed onboarding
    await Future.delayed(const Duration(milliseconds: 100));
    return true; // For demo, assume first time user
  }

  Future<void> _handleInitializationError() async {
    if (!mounted) return;

    await _updateLoadingText('Connection error. Retrying...');
    await Future.delayed(const Duration(milliseconds: 1000));

    // Show retry option
    _showRetryDialog();
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Connection Error',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          content: Text(
            'Unable to initialize the application. Please check your network connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeApp();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login-screen');
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundGradientWidget(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Company Logo with Animation
                    const AnimatedLogoWidget(),

                    SizedBox(height: 3.h),

                    // App Title
                    Text(
                      'KMAsset',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Subtitle
                    Text(
                      'E-Ticketing System',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16.sp,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Loading Indicator
                    LoadingIndicatorWidget(
                      loadingText: _loadingText,
                    ),
                  ],
                ),
              ),

              // Security Badge at Bottom
              if (_showSecurityBadge) ...[
                const SecurityBadgeWidget(),
                SizedBox(height: 4.h),
              ] else ...[
                SizedBox(height: 8.h),
              ],

              // Version Info
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  'Version 1.0.0 • Enterprise Edition',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
