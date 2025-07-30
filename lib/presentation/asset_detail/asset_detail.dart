import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/asset_action_bar.dart';
import './widgets/asset_detail_tabs.dart';
import './widgets/asset_hero_section.dart';
import './widgets/asset_info_cards.dart';
import './widgets/asset_qr_section.dart';

class AssetDetail extends StatefulWidget {
  const AssetDetail({Key? key}) : super(key: key);

  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {
  bool _isLoading = true;
  Map<String, dynamic> _assetData = {};

  // Mock asset data
  final Map<String, dynamic> mockAssetData = {
    "assetId": "AST-2024-001",
    "name": "Dell OptiPlex 7090",
    "category": "Desktop Computer",
    "location": "IT Department - Floor 3",
    "assignedUser": "John Smith",
    "purchaseDate": "2024-01-15",
    "status": "active",
    "images": [
      "https://images.pexels.com/photos/2582937/pexels-photo-2582937.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pixabay.com/photo-2020/05/18/16/17/social-media-5187243_1280.png",
      "https://images.unsplash.com/photo-1547082299-de196ea013d6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
    ],
    "specifications": {
      "Model": "OptiPlex 7090",
      "Processor": "Intel Core i7-11700",
      "RAM": "16GB DDR4",
      "Storage": "512GB SSD",
      "Operating System": "Windows 11 Pro",
      "Serial Number": "DL7090-2024-001"
    },
    "warranty": {
      "startDate": "2024-01-15",
      "endDate": "2027-01-15",
      "provider": "Dell Technologies",
      "coverage": "3-Year ProSupport Plus"
    },
    "history": [
      {
        "title": "Asset Created",
        "description":
            "Asset registered in the system and assigned to IT Department",
        "date": "2024-01-15",
        "type": "info"
      },
      {
        "title": "Assigned to User",
        "description": "Asset assigned to John Smith for daily use",
        "date": "2024-01-20",
        "type": "completed"
      },
      {
        "title": "Software Update",
        "description": "Windows 11 security updates installed",
        "date": "2024-07-15",
        "type": "maintenance"
      },
      {
        "title": "Location Changed",
        "description": "Moved from Floor 2 to Floor 3 - IT Department",
        "date": "2024-07-25",
        "type": "info"
      }
    ],
    "maintenance": [
      {
        "title": "Quarterly System Cleanup",
        "description":
            "Perform disk cleanup, defragmentation, and system optimization",
        "dueDate": "2024-08-15",
        "status": "pending",
        "priority": "medium"
      },
      {
        "title": "Antivirus Update",
        "description":
            "Update antivirus definitions and perform full system scan",
        "dueDate": "2024-08-01",
        "status": "completed",
        "priority": "high"
      },
      {
        "title": "Hardware Inspection",
        "description": "Check all hardware components for wear and tear",
        "dueDate": "2024-09-01",
        "status": "pending",
        "priority": "low"
      }
    ],
    "documents": [
      {
        "name": "Purchase Invoice",
        "type": "pdf",
        "size": "245 KB",
        "uploadDate": "2024-01-15",
        "url": "https://example.com/invoice.pdf"
      },
      {
        "name": "Warranty Certificate",
        "type": "pdf",
        "size": "156 KB",
        "uploadDate": "2024-01-15",
        "url": "https://example.com/warranty.pdf"
      },
      {
        "name": "User Manual",
        "type": "pdf",
        "size": "2.1 MB",
        "uploadDate": "2024-01-20",
        "url": "https://example.com/manual.pdf"
      },
      {
        "name": "Configuration Settings",
        "type": "docx",
        "size": "89 KB",
        "uploadDate": "2024-07-15",
        "url": "https://example.com/config.docx"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadAssetData();
  }

  Future<void> _loadAssetData() async {
    // Simulate loading delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _assetData = mockAssetData;
      _isLoading = false;
    });
  }

  void _handleCameraPressed() {
    // Handle camera functionality for adding photos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Camera functionality would open here'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShareQr() {
    // Handle QR code sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR code shared successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleReportIssue() {
    // Navigate to report issue screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report Issue functionality'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleScheduleMaintenance() {
    // Navigate to schedule maintenance screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Schedule Maintenance functionality'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTransferAsset() {
    // Navigate to transfer asset screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transfer Asset functionality'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleEditAsset() {
    // Navigate to edit asset screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit Asset functionality'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShareAsset() {
    // Handle asset sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Asset details shared'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          _isLoading
              ? 'Asset Detail'
              : (_assetData['name']?.toString() ?? 'Asset Detail'),
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleShareAsset,
            icon: CustomIconWidget(
              iconName: 'share',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: _handleEditAsset,
            icon: CustomIconWidget(
              iconName: 'edit',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ],
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading
          ? _buildLoadingState()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section with Image Gallery
                        AssetHeroSection(
                          assetData: _assetData,
                          onCameraPressed: _handleCameraPressed,
                        ),

                        // Asset Information Cards
                        AssetInfoCards(assetData: _assetData),

                        // Tabbed Content Section
                        AssetDetailTabs(assetData: _assetData),

                        // QR Code Section
                        AssetQrSection(
                          assetData: _assetData,
                          onShareQr: _handleShareQr,
                        ),

                        // Bottom padding for action bar
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _isLoading
          ? null
          : AssetActionBar(
              onReportIssue: _handleReportIssue,
              onScheduleMaintenance: _handleScheduleMaintenance,
              onTransferAsset: _handleTransferAsset,
            ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero section skeleton
          Container(
            height: 35.h,
            width: double.infinity,
            color: AppTheme.lightTheme.colorScheme.surface,
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),

          // Info cards skeleton
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildSkeletonCard()),
                    SizedBox(width: 3.w),
                    Expanded(child: _buildSkeletonCard()),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(child: _buildSkeletonCard()),
                    SizedBox(width: 3.w),
                    Expanded(child: _buildSkeletonCard()),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(child: _buildSkeletonCard()),
                    SizedBox(width: 3.w),
                    Expanded(child: _buildSkeletonCard()),
                  ],
                ),
              ],
            ),
          ),

          // Loading message
          Container(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Loading asset details...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      height: 12.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
    );
  }
}
