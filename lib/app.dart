import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class SpinRitualApp extends StatelessWidget {
  const SpinRitualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '\u8f6c\u4e00\u4e0b',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeScreen(),
    );
  }
}
