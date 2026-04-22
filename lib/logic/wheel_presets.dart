import '../models/wheel_data.dart';
import '../models/wheel_option.dart';
import '../models/wheel_type.dart';
import '../theme/app_colors.dart';

class WheelPresets {
  const WheelPresets._();

  static final WheelData food = WheelData(
    title: '\u4eca\u665a\u5403\u4ec0\u4e48',
    type: WheelType.food,
    options: <WheelOption>[
      WheelOption(
        title: '\u706b\u9505',
        color: AppColors.wheelGradients[0],
        weight: 1.2,
      ),
      WheelOption(
        title: '\u5bff\u53f8',
        color: AppColors.wheelGradients[1],
        weight: 0.9,
      ),
      WheelOption(
        title: '\u6c49\u5821',
        color: AppColors.wheelGradients[2],
        weight: 1.1,
      ),
      WheelOption(
        title: '\u70e4\u8089',
        color: AppColors.wheelGradients[3],
        weight: 1.0,
      ),
      WheelOption(
        title: '\u8f7b\u98df',
        color: AppColors.wheelGradients[0],
        weight: 0.8,
      ),
      WheelOption(
        title: '\u7c89\u9762',
        color: AppColors.wheelGradients[1],
        weight: 1.1,
      ),
      WheelOption(
        title: '\u70b8\u9e21',
        color: AppColors.wheelGradients[2],
        weight: 0.95,
      ),
      WheelOption(
        title: '\u7802\u9505\u83dc',
        color: AppColors.wheelGradients[3],
        weight: 0.9,
      ),
    ],
  );

  static final WheelData time = WheelData(
    title: '\u4ec0\u4e48\u65f6\u5019\u51fa\u53d1',
    type: WheelType.time,
    options: <WheelOption>[
      WheelOption(
        title: '\u7acb\u523b',
        color: AppColors.wheelGradients[1],
        weight: 0.9,
      ),
      WheelOption(
        title: '10 \u5206\u949f',
        color: AppColors.wheelGradients[0],
        weight: 1.0,
      ),
      WheelOption(
        title: '20 \u5206\u949f',
        color: AppColors.wheelGradients[3],
        weight: 1.1,
      ),
      WheelOption(
        title: '30 \u5206\u949f',
        color: AppColors.wheelGradients[2],
        weight: 1.0,
      ),
      WheelOption(
        title: '45 \u5206\u949f',
        color: AppColors.wheelGradients[1],
        weight: 0.8,
      ),
      WheelOption(
        title: '1 \u5c0f\u65f6',
        color: AppColors.wheelGradients[0],
        weight: 0.7,
      ),
    ],
  );
}
