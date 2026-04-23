import 'package:flutter/widgets.dart';

import 'app.dart';
import 'services/wheel_config_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WheelConfigController.instance.initialize();
  runApp(const SpinRitualApp());
}
