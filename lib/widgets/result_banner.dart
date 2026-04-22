import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

class ResultBanner extends StatelessWidget {
  const ResultBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.visible,
  });

  final String title;
  final String subtitle;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: visible ? 1 : 0,
      child: IgnorePointer(
        ignoring: !visible,
        child:
            Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: <Color>[Color(0xFF1F2141), Color(0xFF292C57)],
                    ),
                    border: Border.all(color: AppColors.white38),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: AppColors.edgeGlow,
                        blurRadius: 14,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                )
                .animate(target: visible ? 1 : 0)
                .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1))
                .fadeIn(duration: 320.ms),
      ),
    );
  }
}
