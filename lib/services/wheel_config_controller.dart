import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/wheel_presets.dart';
import '../models/wheel_data.dart';
import '../models/wheel_option.dart';
import '../models/wheel_type.dart';
import '../theme/app_colors.dart';

class WheelConfigController extends ChangeNotifier {
  static const String _foodStorageKey = 'wheel_config_food';
  static const String _timeStorageKey = 'wheel_config_time';

  WheelConfigController._()
    : _food = _cloneWheelData(WheelPresets.food),
      _time = _cloneWheelData(WheelPresets.time);

  static final WheelConfigController instance = WheelConfigController._();

  WheelData _food;
  WheelData _time;
  bool _isInitialized = false;

  WheelData get food => _food;
  WheelData get time => _time;
  bool get isInitialized => _isInitialized;

  WheelData dataForType(WheelType type) {
    return type == WheelType.food ? _food : _time;
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final SharedPreferences preferences = await SharedPreferences.getInstance();

    _food = _readStoredWheelData(
      preferences,
      key: _foodStorageKey,
      fallback: WheelPresets.food,
    );
    _time = _readStoredWheelData(
      preferences,
      key: _timeStorageKey,
      fallback: WheelPresets.time,
    );
    _isInitialized = true;
    notifyListeners();
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
    _persistType(type);
  }

  Future<void> _persistType(WheelType type) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKeyForType(type),
      jsonEncode(dataForType(type).toJson()),
    );
  }

  static WheelData _readStoredWheelData(
    SharedPreferences preferences, {
    required String key,
    required WheelData fallback,
  }) {
    final String? raw = preferences.getString(key);
    if (raw == null || raw.isEmpty) {
      return _cloneWheelData(fallback);
    }

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return _cloneWheelData(fallback);
      }

      final WheelData data = WheelData.fromJson(decoded);
      if (data.options.length < 2) {
        return _cloneWheelData(fallback);
      }

      return data.copyWith(
        options: List<WheelOption>.generate(data.options.length, (int index) {
          final WheelOption option = data.options[index];
          return option.copyWith(
            color: option.color.isEmpty
                ? List<Color>.from(
                    AppColors.wheelGradients[index %
                        AppColors.wheelGradients.length],
                  )
                : List<Color>.from(option.color),
          );
        }),
      );
    } catch (_) {
      return _cloneWheelData(fallback);
    }
  }

  static String _storageKeyForType(WheelType type) {
    return switch (type) {
      WheelType.food => _foodStorageKey,
      WheelType.time => _timeStorageKey,
    };
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
