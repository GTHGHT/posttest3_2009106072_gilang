import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../util/theme_notifier.dart';
import 'screens/setting_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blueAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.greenAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            primary: Colors.greenAccent,
          ),
        ),
      ),
      themeMode: context.watch<ThemeNotifier>().themeMode,
      home: const SettingScreen(),
    );
  }
}