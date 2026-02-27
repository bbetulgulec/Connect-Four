import 'package:connect_four/app/presentations/main/provider/main_provider.dart';
import 'package:connect_four/core/service/hive_service.dart';
import 'package:connect_four/app/presentations/main/view/main_screen.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:connect_four/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LoginProvider extends ChangeNotifier {
  bool isMuted = false;
  bool isClosedVibration = false;
  bool isNotificationEnabled = false;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LoginProvider() {
    _loadSettings();
  }

  void contuniePage(BuildContext context) {
    final savedData = HiveService.getData('current_game');

    if (savedData != null && savedData['isGameOver'] != true) {
      Navigation.pushAndRemoveAll(page: MainScreen());
    } else {
      newGame(context);
    }
  }

  // LoginProvider.dart içinde

  Future<void> newGame(BuildContext context) async {
    // 1. Önce Hive'daki eski oyunu sil
    await HiveService.deleteData('current_game');

    context.read<MainProvider>().setupNewGame();

    // 3. Oyun ekranına git
    Navigation.pushAndRemoveAll(page: const MainScreen());
  }

  void _loadSettings() {
    final voiceData = HiveService.getData('voice');
    final vibrationData = HiveService.getData('vibration');
    final notificationData = HiveService.getData('notifications');

    isMuted = voiceData?['enabled'] ?? false;
    isClosedVibration = vibrationData?['enabled'] ?? false;
    isNotificationEnabled = notificationData?['enabled'] ?? false;

    notifyListeners();
  }

  Future<void> setNotificationEnabled(bool value) async {
    isNotificationEnabled = value;
    notifyListeners();

    await HiveService.saveData('notifications', {'enabled': value});

    if (value) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: 0,
        title: 'Günlük Hatırlatma ',
        body: ' Oyuna girip günlük ödülünü almayı unutma',
        scheduledDate: _nextInstanceOfTenAM(),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel_id',
            'Daily Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else {
      await flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      14,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> voiceSwitch(bool value) async {
    isMuted = !value;
    notifyListeners();

    await HiveService.saveData('voice', {'enabled': isMuted});

    if (value) {
      await mainPlayer.setVolume(1.0);
      await mainPlayer.resume();
    } else {
      await mainPlayer.setVolume(0.0);
      await mainPlayer.pause();
    }
  }

  Future<void> vibrationSwitch(bool value) async {
    isClosedVibration = value;
    notifyListeners();

    await HiveService.saveData('vibration', {'enabled': value});

    if (value) {
      Vibration.cancel();
    } else {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 50);
      }
    }
  }

  Future<void> longAlarmBuzz() async {
    final vibrationData = HiveService.getData('vibration');
    final isVibrationEnabled = vibrationData?['enabled'] ?? true;

    if (isVibrationEnabled && await Vibration.hasVibrator() == true) {
      await Vibration.vibrate(preset: VibrationPreset.longAlarmBuzz);
    }
  }
}
