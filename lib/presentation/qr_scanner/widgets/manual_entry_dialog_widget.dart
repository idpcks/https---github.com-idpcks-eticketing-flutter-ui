import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualEntryDialogWidget extends StatefulWidget {
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  const ManualEntryDialogWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<ManualEntryDialogWidget> createState() =>
      _ManualEntryDialogWidgetState();
}

class _ManualEntryDialogWidgetState extends State<ManualEntryDialogWidget> {
  final TextEditingController _assetIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _assetIdController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate processing delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          widget.onSubmit(_assetIdController.text.trim());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 85.w,
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manual Entry',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: _isSubmitting ? null : widget.onCancel,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              'Enter the asset ID manually if the QR code is damaged or unreadable.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            // Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asset ID',
                    style: AppTheme.lightTheme.textTheme.labelLarge,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _assetIdController,
                    enabled: !_isSubmitting,
                    decoration: InputDecoration(
                      hintText: 'Enter asset ID (e.g., AST-001)',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'qr_code',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an asset ID';
                      }
                      if (value.trim().length < 3) {
                        return 'Asset ID must be at least 3 characters';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (_) => _handleSubmit(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : widget.onCancel,
                    child: Text(
                      'Cancel',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    child: _isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Submit',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Help text
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Asset IDs are usually found on asset labels or in your IT inventory system.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
