import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/company_logo_widget.dart';
import './widgets/credential_input_widget.dart';
import './widgets/login_actions_widget.dart';
import 'widgets/biometric_auth_widget.dart';
import 'widgets/company_logo_widget.dart';
import 'widgets/credential_input_widget.dart';
import 'widgets/login_actions_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isCredentialsValid = false;
  String _errorMessage = '';
  bool _isBiometricEnabled = false;

  // Mock credentials for different user types
  final List<Map<String, dynamic>> _mockCredentials = [
    {
      "email": "admin@kmasset.com",
      "password": "Admin123!",
      "role": "IT Administrator",
      "name": "John Smith"
    },
    {
      "email": "employee@kmasset.com",
      "password": "Employee123!",
      "role": "Employee",
      "name": "Sarah Johnson"
    },
    {
      "email": "manager@kmasset.com",
      "password": "Manager123!",
      "role": "Facility Manager",
      "name": "Michael Brown"
    },
    {
      "email": "support@kmasset.com",
      "password": "Support123!",
      "role": "Technical Support",
      "name": "Emily Davis"
    }
  ];

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricStatus() async {
    // Simulate checking if biometric was previously enabled
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isBiometricEnabled =
            false; // Initially disabled until first successful login
      });
    }
  }

  void _onCredentialsChanged(String email, String password) {
    setState(() {
      _email = email;
      _password = password;
      _isCredentialsValid = email.isNotEmpty &&
          password.isNotEmpty &&
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(email) &&
          password.length >= 8;
      _errorMessage = '';
    });
  }

  Future<void> _handleLogin() async {
    if (!_isCredentialsValid || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 2000));

      // Check credentials against mock data
      final matchingCredential = _mockCredentials.firstWhere(
        (cred) => cred["email"] == _email && cred["password"] == _password,
        orElse: () => {},
      );

      if (matchingCredential.isNotEmpty) {
        // Successful authentication
        HapticFeedback.mediumImpact();

        // Enable biometric for future logins
        setState(() {
          _isBiometricEnabled = true;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${matchingCredential["name"]}!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(4.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Navigate to dashboard
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        // Invalid credentials
        HapticFeedback.heavyImpact();
        setState(() {
          _errorMessage =
              'Invalid email or password. Please check your credentials and try again.';
        });
      }
    } catch (e) {
      // Network or other error
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage =
            'Unable to connect to the server. Please check your internet connection and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBiometricSuccess() {
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Biometric authentication successful!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Navigate to dashboard
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Password Reset',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Please contact your IT administrator to reset your password. You can also use the "Contact IT Support" option below.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'support_agent',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'IT Support',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information:',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 2.h),
            _buildContactInfo('Phone', '+1 (555) 123-4567', 'phone'),
            SizedBox(height: 1.h),
            _buildContactInfo('Email', 'support@kmasset.com', 'email'),
            SizedBox(height: 1.h),
            _buildContactInfo('Hours', 'Mon-Fri 8AM-6PM EST', 'schedule'),
            SizedBox(height: 2.h),
            Text(
              'For immediate assistance with account lockouts or password resets, please call the support line.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildContactInfo(String label, String value, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 18,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  SizedBox(height: 8.h),

                  // Company Logo
                  CompanyLogoWidget(),

                  SizedBox(height: 6.h),

                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      margin: EdgeInsets.only(bottom: 3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.error,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error',
                            color: AppTheme.lightTheme.colorScheme.error,
                            size: 5.w > 24 ? 24 : 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onErrorContainer,
                                fontSize: 3.5.w > 14 ? 14 : 3.5.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Credential Input
                  CredentialInputWidget(
                    onCredentialsChanged: _onCredentialsChanged,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 7.h,
                    child: ElevatedButton(
                      onPressed: _isCredentialsValid && !_isLoading
                          ? _handleLogin
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCredentialsValid
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        foregroundColor: Colors.white,
                        elevation: _isCredentialsValid ? 2 : 0,
                        shadowColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 5.w,
                                  height: 5.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  'Signing In...',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 4.w > 16 ? 16 : 4.w,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Sign In',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: Colors.white,
                                fontSize: 4.w > 16 ? 16 : 4.w,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricSuccess: _handleBiometricSuccess,
                    isEnabled: _isBiometricEnabled && !_isLoading,
                  ),

                  SizedBox(height: 4.h),

                  // Login Actions
                  LoginActionsWidget(
                    onForgotPassword: _handleForgotPassword,
                    onContactSupport: _handleContactSupport,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}