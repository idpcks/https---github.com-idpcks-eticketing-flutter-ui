import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/asset_detail/asset_detail.dart';
import '../presentation/asset_list/asset_list.dart';
import '../presentation/qr_scanner/qr_scanner.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String dashboard = '/dashboard';
  static const String loginScreen = '/login-screen';
  static const String assetDetail = '/asset-detail';
  static const String assetList = '/asset-list';
  static const String qrScanner = '/qr-scanner';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    dashboard: (context) => const Dashboard(),
    loginScreen: (context) => const LoginScreen(),
    assetDetail: (context) => const AssetDetail(),
    assetList: (context) => const AssetList(),
    qrScanner: (context) => const QrScanner(),
    // TODO: Add your other routes here
  };
}
