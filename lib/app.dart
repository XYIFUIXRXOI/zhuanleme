import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class SpinRitualApp extends StatelessWidget {
  const SpinRitualApp({super.key});

  @override
  Widget build(BuildContext context) {
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF151528),
      systemNavigationBarIconBrightness: Brightness.light,
    );

    return MaterialApp(
      title: '\u8f6c\u4e00\u4e0b',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      builder: (BuildContext context, Widget? child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
    );
  }
}
