import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onQRScan;
  final VoidCallback? onFilter;

  const SearchBarWidget({
    Key? key,
    this.hintText = 'Search assets...',
    this.controller,
    this.onChanged,
    this.onQRScan,
    this.onFilter,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _controller.text.isNotEmpty;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _isSearching = false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _isSearching
                    ? GestureDetector(
                        onTap: _clearSearch,
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'clear',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
            ),
          ),
          if (widget.onQRScan != null) ...[
            Container(
              width: 1,
              height: 6.h,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            GestureDetector(
              onTap: widget.onQRScan,
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Theme.of(context).colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
          ],
          if (widget.onFilter != null) ...[
            Container(
              width: 1,
              height: 6.h,
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
            GestureDetector(
              onTap: widget.onFilter,
              child: Container(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'tune',
                  color: Theme.of(context).colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
