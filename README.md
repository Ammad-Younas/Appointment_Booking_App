# Appointment Booking App

A Flutter project for building an appointment booking application (mobile & desktop).

## Overview

This repository contains a Flutter application scaffolded to implement appointment booking flows. The code is organized with clear layers (controllers, services, data sources, models, and views) under `lib/`.

Highlights

- Dart SDK constraint: ^3.9.2 (see `pubspec.yaml`)
- Uses `flutter_native_splash` for native splash screens
- Custom Ubuntu font included in `assets/fonts/`

## Prerequisites

- Flutter SDK (stable channel recommended). Install from https://flutter.dev
- A Dart SDK compatible with the project's constraint (>= 3.9.2)
- Platform toolchains for the target platforms you plan to run (Android SDK, Xcode for iOS on macOS, etc.)

## Quick start

1. Install dependencies:

   flutter pub get

2. Run the app on an available device/emulator:

   flutter run

Run on a specific device:

- Android: flutter run -d android
- iOS (macOS required): flutter run -d ios
- Windows: flutter run -d windows
- Web (Chrome): flutter run -d chrome

## Build

Build an APK for Android:

flutter build apk

Build for iOS (requires macOS):

flutter build ios

## Project structure

- android/, ios/, linux/, macos/, windows/ — native platform projects
- assets/ — fonts, images and other static resources
- lib/ — main application code
  - controllers/ — controllers and state management
  - data/
    - local/ — local persistence helpers
    - remote/ — API clients and remote data sources
  - models/ — data models and DTOs
  - services/ — business logic and helpers
  - src/
    - views/ — UI screens and widgets
  - utils/ — utilities and common helpers
  - app_colors.dart — color constants
  - main.dart — application entrypoint

## Tests

Run unit and widget tests with:

flutter test

## Notes & tips

- The project uses `flutter_native_splash`. After modifying splash settings in `pubspec.yaml`, regenerate the native splash with the package's instructions (for example, `flutter pub run flutter_native_splash:create`).
- When adding new assets (fonts, images), register them in `pubspec.yaml`.

## Contributing

Contributions are welcome. Please open issues or pull requests with clear descriptions and reproduction steps.

## License & contact

No license is included in this repository. Add a LICENSE file (for example MIT) if you wish to open-source the repo.

For questions, contact the repository owner.
