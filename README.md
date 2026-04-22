# zhuleme

An interactive Flutter roulette app driven by tap and motion input.

Users can spin the wheel by pressing a button or shaking the phone. The wheel is rendered with `CustomPainter`, animated with smooth deceleration, and used to produce a final visual result. The app currently includes two built-in wheel types: food selection and time selection. The home screen also provides a configuration drawer for editing wheel content directly inside the app.

## Features

- Tap to start a wheel spin
- Shake to trigger a wheel spin
- Custom wheel rendering with `CustomPainter`
- Smooth deceleration animation
- Editable wheel content from the home screen drawer
- Add, edit, delete, and reset wheel options
- Neon-inspired dark UI

## Tech Stack

- Flutter
- Dart
- `sensors_plus`
- `flutter_animate`

## Project Structure

```text
lib/
├── app.dart
├── main.dart
├── logic/
├── models/
├── screens/
├── services/
├── theme/
└── widgets/
```

### Main Modules

- `screens/`
  Page-level UI such as the home screen and wheel screen
- `widgets/`
  Reusable UI pieces such as the wheel, pointer, result banner, and config drawer
- `logic/`
  Spin math, constants, and built-in wheel presets
- `services/`
  Sensor listening and wheel configuration management
- `models/`
  Wheel-related data models
- `theme/`
  Shared colors and theme configuration

## Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Run the app

```bash
flutter run
```

### 3. Build an Android debug APK

```bash
flutter build apk --debug
```

## Usage

### Home Screen

- Open the food wheel
- Open the time wheel
- Tap the top-left menu icon to open the configuration drawer

### Configuration Drawer

- Edit wheel options for food and time wheels
- Add new options
- Delete existing options
- Restore default content

### Wheel Screen

- Tap `Start Spin` to launch a manual spin
- Shake the phone to trigger a sensor-based spin
- Wait for the wheel to decelerate and stop
- View the final selected result

## Current Behavior

- Final result is based on the actual final animation position
- The wheel stops with smooth deceleration and no bounce-back
- Shake sensitivity, spin speed, and spin duration have been tuned for multiple intensity levels
- The installed app display name is set to `转了么`

## Development Checks

Useful commands during development:

```bash
flutter analyze
flutter test
```

## Possible Future Improvements

- Persist wheel configuration locally
- Add more wheel themes and skins
- Improve sensor intensity mapping
- Add result history

## License

This project is intended for learning and product prototyping purposes.
