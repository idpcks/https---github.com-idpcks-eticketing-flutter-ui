import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> activity;
  final VoidCallback? onTap;
  final VoidCallback? onArchive;

  const ActivityItemWidget({
    Key? key,
    required this.activity,
    this.onTap,
    this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String type = activity['type'] ?? 'general';
    final String title = activity['title'] ?? 'Activity';
    final String description = activity['description'] ?? '';
    final String timestamp = activity['timestamp'] ?? '';
    final String priority = activity['priority'] ?? 'normal';
    final String? assetImage = activity['assetImage'];
    final String status = activity['status'] ?? 'active';

    return Dismissible(
      key: Key(activity['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (onArchive != null) {
          onArchive!();
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'archive',
          color: theme.colorScheme.error,
          size: 6.w,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () {
          _showContextMenu(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
            border: isDark
                ? Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity type icon or asset thumbnail
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _getTypeColor(type, theme).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: assetImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: assetImage,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: CustomIconWidget(
                          iconName: _getTypeIcon(type),
                          color: _getTypeColor(type, theme),
                          size: 6.w,
                        ),
                      ),
              ),
              SizedBox(width: 3.w),
              // Activity content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (priority != 'normal') ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(priority, theme)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              priority.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _getPriorityColor(priority, theme),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (description.isNotEmpty) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          timestamp,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.getStatusColor(status,
                                    isLight: !isDark)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.getStatusColor(status,
                                  isLight: !isDark),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                if (onTap != null) onTap!();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'archive',
                color: Theme.of(context).colorScheme.error,
                size: 6.w,
              ),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                if (onArchive != null) onArchive!();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'ticket':
        return 'confirmation_number';
      case 'asset':
        return 'inventory_2';
      case 'maintenance':
        return 'build';
      case 'assignment':
        return 'assignment';
      default:
        return 'notifications';
    }
  }

  Color _getTypeColor(String type, ThemeData theme) {
    switch (type.toLowerCase()) {
      case 'ticket':
        return theme.colorScheme.primary;
      case 'asset':
        return theme.colorScheme.tertiary;
      case 'maintenance':
        return Colors.orange;
      case 'assignment':
        return Colors.purple;
      default:
        return theme.colorScheme.secondary;
    }
  }

  Color _getPriorityColor(String priority, ThemeData theme) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'critical':
        return theme.colorScheme.error;
      case 'medium':
        return Colors.orange;
      case 'low':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.secondary;
    }
  }
}
