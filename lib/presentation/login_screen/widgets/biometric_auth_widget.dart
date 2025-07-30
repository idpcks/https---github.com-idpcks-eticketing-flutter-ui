import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricSuccess;
  final bool isEnabled;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricSuccess,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isBiometricAvailable = false;
  bool _isAuthenticating = false;
  String _biometricType = 'Biometric';

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Simulate biometric availability check
      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          _isBiometricAvailable = true;
          // Simulate different biometric types based on platform
          _biometricType = Theme.of(context).platform == TargetPlatform.iOS
              ? 'Face ID / Touch ID'
              : 'Fingerprint / Face Unlock';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBiometricAvailable = false;
        });
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!widget.isEnabled || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Simulate biometric authentication
      await Future.delayed(Duration(milliseconds: 1500));

      // Simulate successful authentication (80% success rate)
      final isSuccess = DateTime.now().millisecond % 5 != 0;

      if (isSuccess) {
        HapticFeedback.heavyImpact();
        widget.onBiometricSuccess();
      } else {
        HapticFeedback.vibrate();
        _showBiometricError('Authentication failed. Please try again.');
      }
    } catch (e) {
      _showBiometricError('Biometric authentication is not available.');
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _showBiometricError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          // Divider with "OR" text
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 3.w > 12 ? 12 : 3.w,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Biometric Authentication Button
          GestureDetector(
            onTap: widget.isEnabled ? _authenticateWithBiometrics : null,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 20.w,
              height: 10.h,
              constraints: BoxConstraints(
                maxWidth: 100,
                maxHeight: 100,
                minWidth: 80,
                minHeight: 80,
              ),
              decoration: BoxDecoration(
                color: widget.isEnabled
                    ? AppTheme.lightTheme.colorScheme.primaryContainer
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: widget.isEnabled
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 2,
                ),
                boxShadow: widget.isEnabled
                    ? [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          offset: Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: _isAuthenticating
                    ? SizedBox(
                        width: 6.w,
                        height: 6.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      )
                    : CustomIconWidget(
                        iconName:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? 'face'
                                : 'fingerprint',
                        color: widget.isEnabled
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 8.w > 40 ? 40 : 8.w,
                      ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Biometric Authentication Label
          Text(
            _isAuthenticating ? 'Authenticating...' : 'Use $_biometricType',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 3.5.w > 14 ? 14 : 3.5.w,
              color: widget.isEnabled
                  ? AppTheme.lightTheme.colorScheme.onSurface
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          if (!widget.isEnabled)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                'Complete login once to enable biometric authentication',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontSize: 3.w > 12 ? 12 : 3.w,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}