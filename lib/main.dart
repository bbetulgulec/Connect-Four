import 'package:connect_four/app/presentations/onboarding/view/onboarding_view.dart';
import 'package:connect_four/core/helper/nav_helper/navigation_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Navigation.navigationKey,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: OnboardingView(),
    );
  }
}
