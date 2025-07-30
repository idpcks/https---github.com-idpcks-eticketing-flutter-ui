import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/asset_bottom_sheet_widget.dart';
import './widgets/bottom_overlay_widget.dart';
import './widgets/camera_overlay_widget.dart';
import './widgets/manual_entry_dialog_widget.dart';
import './widgets/permission_overlay_widget.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _hasPermission = false;
  bool _isFlashOn = false;
  bool _isScanning = false;
  bool _showPermissionOverlay = false;
  String? _lastScannedCode;
  DateTime? _lastScanTime;

  // Mock data for recent scans
  final List<Map<String, dynamic>> _recentScans = [
    {
      "assetId": "AST-001",
      "type": "laptop",
      "scannedAt": DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      "assetId": "AST-045",
      "type": "printer",
      "scannedAt": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "assetId": "AST-123",
      "type": "monitor",
      "scannedAt": DateTime.now().subtract(const Duration(hours: 2)),
    },
  ];

  // Mock asset data
  final Map<String, Map<String, dynamic>> _mockAssets = {
    "AST-001": {
      "assetId": "AST-001",
      "name": "Dell Latitude 7420 Laptop",
      "type": "laptop",
      "status": "active",
      "location": "Floor 3, Desk 15",
      "department": "Engineering",
      "assignedTo": "John Smith",
      "lastUpdated": "2025-07-29 14:30",
      "description":
          "High-performance laptop for software development with 16GB RAM and 512GB SSD.",
    },
    "AST-045": {
      "assetId": "AST-045",
      "name": "HP LaserJet Pro M404n",
      "type": "printer",
      "status": "maintenance",
      "location": "Floor 2, Print Station",
      "department": "Operations",
      "assignedTo": "Facility Team",
      "lastUpdated": "2025-07-28 09:15",
      "description":
          "Network printer for general office use, currently under maintenance.",
    },
    "AST-123": {
      "assetId": "AST-123",
      "name": "Samsung 27\" Monitor",
      "type": "monitor",
      "status": "active",
      "location": "Floor 1, Reception",
      "department": "Administration",
      "assignedTo": "Sarah Johnson",
      "lastUpdated": "2025-07-30 08:45",
      "description":
          "4K display monitor for reception area information display.",
    },
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      final hasPermission = await _requestCameraPermission();

      if (!hasPermission) {
        setState(() {
          _showPermissionOverlay = true;
        });
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showErrorSnackBar('No cameras available on this device');
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!kIsWeb) {
        try {
          await _cameraController!.setFocusMode(FocusMode.auto);
          await _cameraController!.setFlashMode(FlashMode.off);
        } catch (e) {
          // Ignore flash/focus errors on unsupported devices
        }
      }

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          _hasPermission = true;
          _showPermissionOverlay = false;
        });
        _startScanning();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to initialize camera');
    }
  }

  void _startScanning() {
    if (!_isScanning && _isCameraInitialized) {
      setState(() {
        _isScanning = true;
      });
      _simulateScanning();
    }
  }

  void _simulateScanning() {
    // Simulate QR code detection after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isScanning) {
        _onQRCodeDetected("AST-001");
      }
    });
  }

  void _onQRCodeDetected(String code) {
    final now = DateTime.now();

    // Prevent duplicate scans within 2 seconds
    if (_lastScannedCode == code &&
        _lastScanTime != null &&
        now.difference(_lastScanTime!).inSeconds < 2) {
      return;
    }

    _lastScannedCode = code;
    _lastScanTime = now;

    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Stop scanning temporarily
    setState(() {
      _isScanning = false;
    });

    _lookupAsset(code);
  }

  void _lookupAsset(String assetId) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Looking up asset...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate asset lookup
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(); // Close loading dialog

      final assetData = _mockAssets[assetId];
      if (assetData != null) {
        _showAssetBottomSheet(assetData);
        _addToRecentScans(assetId, assetData['type'] as String);
      } else {
        _showErrorSnackBar('Asset not found: $assetId');
        _resumeScanning();
      }
    });
  }

  void _addToRecentScans(String assetId, String type) {
    setState(() {
      _recentScans.removeWhere((scan) => scan['assetId'] == assetId);
      _recentScans.insert(0, {
        "assetId": assetId,
        "type": type,
        "scannedAt": DateTime.now(),
      });
      if (_recentScans.length > 5) {
        _recentScans.removeLast();
      }
    });
  }

  void _showAssetBottomSheet(Map<String, dynamic> assetData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssetBottomSheetWidget(
        assetData: assetData,
        onViewDetails: () {
          Navigator.of(context).pop();
          Navigator.pushNamed(context, '/asset-detail');
        },
        onReportIssue: () {
          Navigator.of(context).pop();
          _showSuccessSnackBar('Issue report created');
          _resumeScanning();
        },
        onUpdateStatus: () {
          Navigator.of(context).pop();
          _showSuccessSnackBar('Status updated successfully');
          _resumeScanning();
        },
        onClose: () {
          Navigator.of(context).pop();
          _resumeScanning();
        },
      ),
    );
  }

  void _resumeScanning() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isScanning = true;
        });
        _simulateScanning();
      }
    });
  }

  void _toggleFlash() async {
    if (!kIsWeb && _cameraController != null) {
      try {
        await _cameraController!
            .setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
        setState(() {
          _isFlashOn = !_isFlashOn;
        });
      } catch (e) {
        _showErrorSnackBar('Flash not available');
      }
    }
  }

  void _showManualEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => ManualEntryDialogWidget(
        onSubmit: (assetId) {
          Navigator.of(context).pop();
          _lookupAsset(assetId);
        },
        onCancel: () {
          Navigator.of(context).pop();
          _resumeScanning();
        },
      ),
    );
  }

  void _showRecentScans() {
    Navigator.pushNamed(context, '/asset-list');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showPermissionOverlay) {
      return Scaffold(
        body: PermissionOverlayWidget(
          onAllowCamera: () async {
            setState(() {
              _showPermissionOverlay = false;
            });
            await _initializeCamera();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing camera...',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          // Camera overlay
          CameraOverlayWidget(
            onClose: () => Navigator.of(context).pop(),
            onFlashToggle: _toggleFlash,
            isFlashOn: _isFlashOn,
            isWeb: kIsWeb,
          ),
          // Bottom overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomOverlayWidget(
              onManualEntry: _showManualEntryDialog,
              onRecentScans: _showRecentScans,
              recentScans: _recentScans,
            ),
          ),
          // Scanning indicator
          if (_isScanning)
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Scanning...',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
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
