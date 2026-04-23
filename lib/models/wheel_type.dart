enum WheelType { food, time }

extension WheelTypeX on WheelType {
  String get storageKey {
    return switch (this) {
      WheelType.food => 'food',
      WheelType.time => 'time',
    };
  }

  static WheelType fromStorageKey(String value) {
    return WheelType.values.firstWhere(
      (WheelType type) => type.storageKey == value,
      orElse: () => WheelType.food,
    );
  }
}
