import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'theme.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

// ZegoCloud Call Navigation Key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Requires google-services.json)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase Init Error: $e");
  }

  // Initialize OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("YOUR_ONESIGNAL_APP_ID"); // TODO: Replace with your ID
  OneSignal.Notifications.requestPermission(true);

  // Initialize ZegoCloud
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const ZyloApp(),
    ),
  );
}

class ZyloApp extends StatelessWidget {
  const ZyloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zylo.pages',
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}