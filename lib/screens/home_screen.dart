import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import '../logic/wheel_presets.dart';
import '../theme/app_colors.dart';
import '../widgets/glow_button.dart';
import 'wheel_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.backgroundBottom,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.backgroundTop,
                AppColors.backgroundBottom,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Text(
                        '\u8f6c\u4e00\u4e0b',
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 14),
                  Text(
                        '\u7529\u52a8\u624b\u673a\uff0c\u6216\u8f7b\u89e6\u6309\u94ae\uff0c\u8ba9\u9009\u62e9\u50cf\u4eea\u5f0f\u4e00\u6837\u843d\u5b9a\u3002',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                      .animate(delay: 120.ms)
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.25, end: 0),
                  const Spacer(),
                  GlowButton(
                    label: '\u5403\u4ec0\u4e48',
                    icon: Icons.restaurant_menu_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WheelScreen(data: WheelPresets.food),
                      ),
                    ),
                  ).animate(delay: 220.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 18),
                  GlowButton(
                    label: '\u65f6\u95f4\u8f6c\u76d8',
                    icon: Icons.schedule_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WheelScreen(data: WheelPresets.time),
                      ),
                    ),
                  ).animate(delay: 320.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
