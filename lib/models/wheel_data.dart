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
}
