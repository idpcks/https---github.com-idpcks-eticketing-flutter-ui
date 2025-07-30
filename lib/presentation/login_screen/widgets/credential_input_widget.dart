import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CredentialInputWidget extends StatefulWidget {
  final Function(String email, String password) onCredentialsChanged;
  final bool isLoading;

  const CredentialInputWidget({
    Key? key,
    required this.onCredentialsChanged,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<CredentialInputWidget> createState() => _CredentialInputWidgetState();
}

class _CredentialInputWidgetState extends State<CredentialInputWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  String _emailError = '';
  String _passwordError = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        _isEmailValid = false;
        _emailError = '';
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(email)) {
        _isEmailValid = false;
        _emailError = 'Please enter a valid corporate email address';
      } else {
        _isEmailValid = true;
        _emailError = '';
      }
    });
    _notifyCredentialsChanged();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _isPasswordValid = false;
        _passwordError = '';
      } else if (password.length < 8) {
        _isPasswordValid = false;
        _passwordError = 'Password must be at least 8 characters';
      } else {
        _isPasswordValid = true;
        _passwordError = '';
      }
    });
    _notifyCredentialsChanged();
  }

  void _notifyCredentialsChanged() {
    widget.onCredentialsChanged(
        _emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Input
        Text(
          'Corporate Email',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontSize: 3.5.w > 16 ? 16 : 3.5.w,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          enabled: !widget.isLoading,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          decoration: InputDecoration(
            hintText: 'Enter your corporate email',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email',
                color: _isEmailValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w > 24 ? 24 : 5.w,
              ),
            ),
            suffixIcon: _emailController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: _isEmailValid ? 'check_circle' : 'error',
                      color: _isEmailValid
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 5.w > 20 ? 20 : 5.w,
                    ),
                  )
                : null,
            errorText: _emailError.isNotEmpty ? _emailError : null,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
        ),
        SizedBox(height: 3.h),

        // Password Input
        Text(
          'Password',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontSize: 3.5.w > 16 ? 16 : 3.5.w,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          enabled: !widget.isLoading,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'lock',
                color: _isPasswordValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w > 24 ? 24 : 5.w,
              ),
            ),
            suffixIcon: _passwordController.text.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isPasswordValid)
                        Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 5.w > 20 ? 20 : 5.w,
                          ),
                        ),
                      GestureDetector(
                        onTap: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: _isPasswordVisible
                                ? 'visibility_off'
                                : 'visibility',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w > 24 ? 24 : 5.w,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
            errorText: _passwordError.isNotEmpty ? _passwordError : null,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
        ),

        // Password Strength Indicator
        if (_passwordController.text.isNotEmpty && !_isPasswordValid)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password Requirements:',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontSize: 3.w > 12 ? 12 : 3.w,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                _buildPasswordRequirement(
                  'At least 8 characters',
                  _passwordController.text.length >= 8,
                ),
                _buildPasswordRequirement(
                  'Contains uppercase letter',
                  RegExp(r'[A-Z]').hasMatch(_passwordController.text),
                ),
                _buildPasswordRequirement(
                  'Contains lowercase letter',
                  RegExp(r'[a-z]').hasMatch(_passwordController.text),
                ),
                _buildPasswordRequirement(
                  'Contains number',
                  RegExp(r'[0-9]').hasMatch(_passwordController.text),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check' : 'close',
            color: isMet
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            size: 3.5.w > 16 ? 16 : 3.5.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              requirement,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontSize: 3.w > 12 ? 12 : 3.w,
                color: isMet
                    ? AppTheme.lightTheme.colorScheme.tertiary
                    : AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get isValid => _isEmailValid && _isPasswordValid;
}
