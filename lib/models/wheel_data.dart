import 'wheel_option.dart';
import 'wheel_type.dart';

class WheelData {
  const WheelData({
    required this.title,
    required this.options,
    required this.type,
  });

  final String title;
  final List<WheelOption> options;
  final WheelType type;

  WheelData copyWith({
    String? title,
    List<WheelOption>? options,
    WheelType? type,
  }) {
    return WheelData(
      title: title ?? this.title,
      options: options ?? this.options,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'type': type.storageKey,
      'options': options
          .map((WheelOption option) => option.toJson())
          .toList(growable: false),
    };
  }

  factory WheelData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawOptions =
        json['options'] as List<dynamic>? ?? <dynamic>[];

    return WheelData(
      title: json['title'] as String? ?? '',
      type: WheelTypeX.fromStorageKey(json['type'] as String? ?? 'food'),
      options: rawOptions
          .map(
            (dynamic item) =>
                WheelOption.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
    );
  }
}
