import 'package:audioplayers/audioplayers.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/presentations/login/provider/login_provider.dart';
import 'package:connect_four/app/presentations/login/view/login_view.dart';
import 'package:connect_four/app/presentations/main/provider/main_provider.dart';
import 'package:connect_four/app/presentations/onboarding/provider/onboarding_provider.dart';
import 'package:connect_four/app/presentations/onboarding/view/onboarding_view.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final AudioPlayer mainPlayer = AudioPlayer();

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) {}
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Mobile Ads SDK.
  await MobileAds.instance.initialize();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  await androidPlugin?.requestNotificationsPermission();

  await HiveService.init();

  final bool isMuted = HiveService.getData('voice')?['enabled'] ?? false;

  await mainPlayer.setSource(AssetSource('wav/squeaky_computer_chair.wav'));
  await mainPlayer.setReleaseMode(ReleaseMode.loop); // Müziği döngüye al

  if (!isMuted) {
    await mainPlayer.setVolume(1.0);
    await mainPlayer.resume();
  } else {
    await mainPlayer.setVolume(0.0);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool onboardingShown =
        HiveService.getData('onboarding')?['shown'] ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.navigationKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: onboardingShown ? const LoginView() : const OnboardingView(),
    );
  }
}
