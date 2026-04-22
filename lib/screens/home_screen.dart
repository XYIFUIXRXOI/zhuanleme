import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

import '../services/wheel_config_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/glow_button.dart';
import '../widgets/home_config_drawer.dart';
import 'wheel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final WheelConfigController _controller = WheelConfigController.instance;

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
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: HomeConfigDrawer(controller: _controller),
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
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                          icon: const Icon(Icons.menu_rounded, size: 30),
                          tooltip: '\u914d\u7f6e\u8f6c\u76d8',
                        ),
                      ),
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
                                builder: (_) =>
                                    WheelScreen(data: _controller.food),
                              ),
                            ),
                          )
                          .animate(delay: 220.ms)
                          .fadeIn()
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 18),
                      GlowButton(
                            label: '\u65f6\u95f4\u8f6c\u76d8',
                            icon: Icons.schedule_rounded,
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    WheelScreen(data: _controller.time),
                              ),
                            ),
                          )
                          .animate(delay: 320.ms)
                          .fadeIn()
                          .slideY(begin: 0.2, end: 0),
                      const Spacer(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
