import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/app_constants.dart';
import '../logic/wheel_math.dart';
import '../models/wheel_data.dart';
import '../services/sensor_spin_service.dart';
import '../theme/app_colors.dart';
import '../widgets/glow_button.dart';
import '../widgets/result_banner.dart';
import '../widgets/wheel_board.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key, required this.data});

  final WheelData data;

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;
  late final SensorSpinService _sensorService;
  Animation<double>? _spinAnimation;
  double _currentAngle = 0;
  String? _selectedTitle;
  String _statusText =
      '\u70b9\u51fb\u6309\u94ae\uff0c\u6216\u7529\u52a8\u624b\u673a\u89e6\u53d1\u8f6c\u76d8';
  bool _showResult = false;
  bool _awaitingResultAcknowledge = false;
  double _sensorIntensity = 0;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(vsync: this);
    _sensorService = SensorSpinService()
      ..start(
        onTrigger: (SpinInput input) {
          if (!_spinController.isAnimating && !_awaitingResultAcknowledge) {
            _startSpin(input);
          }
        },
        onFeedback: (SensorFeedback feedback) {
          if (!mounted ||
              _spinController.isAnimating ||
              _showResult ||
              _awaitingResultAcknowledge) {
            return;
          }

          setState(() {
            _sensorIntensity = feedback.intensity;
            _statusText = feedback.message;
          });
        },
      );
  }

  @override
  void dispose() {
    unawaited(_sensorService.dispose());
    _spinController.dispose();
    super.dispose();
  }

  Future<void> _startSpin(SpinInput input) async {
    final SpinPlan plan = WheelMath.buildSpinPlan(
      data: widget.data,
      currentAngle: _currentAngle,
      input: input,
      minTurns: AppConstants.minTurns,
      maxTurns: AppConstants.maxTurns,
      minDuration: AppConstants.minSpinDuration,
      maxDuration: AppConstants.maxSpinDuration,
    );

    _spinController
      ..duration = plan.duration
      ..reset();

    // The last 8% of the timeline eases back from a tiny overshoot so the wheel
    // settles with a soft mechanical buffer instead of a hard stop.
    final TweenSequence<double> spinSequence =
        TweenSequence<double>(<TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: _currentAngle,
              end: plan.overshootAngle,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
            weight: 92,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: plan.overshootAngle,
              end: plan.targetAngle,
            ).chain(CurveTween(curve: Curves.easeOutBack)),
            weight: 8,
          ),
        ]);

    _spinAnimation = spinSequence.animate(_spinController);

    setState(() {
      _showResult = false;
      _awaitingResultAcknowledge = false;
      _sensorIntensity = 1;
      _statusText =
          '${input.sourceLabel} | ${(plan.perceivedVelocity / math.pi).toStringAsFixed(1)} pi rad/s | ${(plan.duration.inMilliseconds / 1000).toStringAsFixed(1)} s';
    });

    await _spinController.forward();

    final double settledAngle = _spinAnimation?.value ?? plan.targetAngle;
    final int resolvedIndex = WheelMath.resolveIndexFromAngle(
      angle: settledAngle,
      itemCount: widget.data.options.length,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _currentAngle = settledAngle;
      _selectedTitle = widget.data.options[resolvedIndex].title;
      _showResult = true;
      _awaitingResultAcknowledge = true;
      _sensorIntensity = 0;
      _statusText = '\u7ed3\u679c\u5df2\u9501\u5b9a';
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('\u547d\u8fd0\u843d\u70b9'),
          content: Text(
            _selectedTitle ?? '',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('\u518d\u770b\u770b'),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _awaitingResultAcknowledge = false;
      _statusText =
          '\u70b9\u51fb\u6309\u94ae\uff0c\u6216\u518d\u6b21\u7529\u52a8\u624b\u673a\u89e6\u53d1\u8f6c\u76d8';
    });
  }

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
            child: AnimatedBuilder(
              animation: _spinController,
              builder: (BuildContext context, Widget? child) {
                final double angle = _spinAnimation?.value ?? _currentAngle;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  widget.data.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _statusText,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                _SensorStrengthBar(intensity: _sensorIntensity),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: Center(
                          child: WheelBoard(data: widget.data, angle: angle),
                        ),
                      ),
                      ResultBanner(
                        title:
                            _selectedTitle ??
                            '\u7b49\u5f85\u547d\u8fd0\u843d\u70b9',
                        subtitle: _showResult
                            ? '\u8fd9\u6b21\u7684\u7b54\u6848\u662f'
                            : '\u51c6\u5907\u5f00\u59cb',
                        visible: _showResult,
                      ),
                      const SizedBox(height: 18),
                      GlowButton(
                        label: _spinController.isAnimating
                            ? '\u65cb\u8f6c\u4e2d...'
                            : _awaitingResultAcknowledge
                            ? '\u8bf7\u5148\u786e\u8ba4\u7ed3\u679c'
                            : '\u5f00\u59cb\u65cb\u8f6c',
                        icon: Icons.auto_awesome_rounded,
                        onPressed:
                            _spinController.isAnimating ||
                                _awaitingResultAcknowledge
                            ? null
                            : () => _startSpin(
                                SpinInput(
                                  intensity: 0.72,
                                  sourceLabel: '\u624b\u52a8\u89e6\u53d1',
                                ),
                              ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '\u63d0\u793a\uff1a\u8f7b\u5feb\u8fde\u7eed\u5730\u7529\u52a8\u624b\u673a\uff0c\u529b\u5ea6\u6761\u4eae\u8d77\u6765\u5c31\u5feb\u89e6\u53d1',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
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

class _SensorStrengthBar extends StatelessWidget {
  const _SensorStrengthBar({required this.intensity});

  final double intensity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 180,
        height: 8,
        color: AppColors.white38.withValues(alpha: 0.12),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: intensity.clamp(0.0, 1.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF4FACFE),
                  Color(0xFF7B61FF),
                  Color(0xFFFFD200),
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.buttonGlow,
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
