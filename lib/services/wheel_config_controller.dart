import 'package:flutter/material.dart';

import '../logic/wheel_presets.dart';
import '../models/wheel_data.dart';
import '../models/wheel_option.dart';
import '../models/wheel_type.dart';
import '../theme/app_colors.dart';

class WheelConfigController extends ChangeNotifier {
  WheelConfigController._()
    : _food = _cloneWheelData(WheelPresets.food),
      _time = _cloneWheelData(WheelPresets.time);

  static final WheelConfigController instance = WheelConfigController._();

  WheelData _food;
  WheelData _time;

  WheelData get food => _food;
  WheelData get time => _time;

  WheelData dataForType(WheelType type) {
    return type == WheelType.food ? _food : _time;
  }

  void updateOptionTitle({
    required WheelType type,
    required int index,
    required String title,
  }) {
    final List<WheelOption> nextOptions = List<WheelOption>.from(
      dataForType(type).options,
    );
    nextOptions[index] = nextOptions[index].copyWith(title: title);
    _setData(type, dataForType(type).copyWith(options: nextOptions));
  }

  void addOption({required WheelType type, required String title}) {
    final WheelData data = dataForType(type);
    final List<WheelOption> nextOptions = List<WheelOption>.from(data.options)
      ..add(
        WheelOption(
          title: title,
          color:
              AppColors.wheelGradients[data.options.length %
                  AppColors.wheelGradients.length],
          weight: 1,
        ),
      );
    _setData(type, data.copyWith(options: nextOptions));
  }

  void removeOption({required WheelType type, required int index}) {
    final WheelData data = dataForType(type);
    if (data.options.length <= 2) {
      return;
    }
    final List<WheelOption> nextOptions = List<WheelOption>.from(data.options)
      ..removeAt(index);
    _setData(type, data.copyWith(options: nextOptions));
  }

  void resetType(WheelType type) {
    _setData(
      type,
      type == WheelType.food
          ? _cloneWheelData(WheelPresets.food)
          : _cloneWheelData(WheelPresets.time),
    );
  }

  void _setData(WheelType type, WheelData data) {
    if (type == WheelType.food) {
      _food = data;
    } else {
      _time = data;
    }
    notifyListeners();
  }

  static WheelData _cloneWheelData(WheelData source) {
    return source.copyWith(
      options: source.options
          .map(
            (WheelOption option) =>
                option.copyWith(color: List<Color>.from(option.color)),
          )
          .toList(),
    );
  }
}
