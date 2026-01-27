import 'package:audioplayers/audioplayers.dart';
import 'package:connect_four/app/data/hive/game_progress.dart';
import 'package:connect_four/app/presentations/login/view/login_view.dart';
import 'package:connect_four/app/presentations/onboarding/view/onboarding_view.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

final AudioPlayer mainPlayer = AudioPlayer(); // global player

void onDidReceiveNotificationResponse(
  NotificationResponse notificationResponse,
) {
  // Handle notification response
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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

  await Hive.initFlutter();

  Hive.registerAdapter(GameProgressAdapter());

  await Hive.openBox<GameProgress>('game');
  await Hive.openBox<bool>('onboarding');
  await Hive.openBox<bool>('vibration');
  final voiceBox = await Hive.openBox<bool>("voice");

  final bool isMuted = voiceBox.get('enabled', defaultValue: false) ?? false;

  await mainPlayer.setSource(AssetSource('wav/squeaky_computer_chair.wav'));

  if (!isMuted) {
    await mainPlayer.setVolume(1.0);
    await mainPlayer.resume();
  } else {
    await mainPlayer.setVolume(0.0);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingBox = Hive.box<bool>('onboarding');

    final bool onboardingShown =
        onboardingBox.get('shown', defaultValue: false) ?? false;

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
