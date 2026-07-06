<p align="center">
  <img src=".logo/nanna-logo-transparent.png" alt="Nanna Logo" width="200"/>
</p>

# nanna

A comprehensive set of utilities, extensions, widgets, and services designed to accelerate Flutter app development. 
This package provides robust solutions for secure storage, notification management, routing wrappers, and common UI patterns.

## Features

- **Services**: Simplified `toastification` based notifications and customizable overlays.
- **Secure Storage**: A streamlined wrapper around `flutter_secure_storage` to handle booleans, dates, and simple strings with ease.
- **Extensions**: Powerful extensions for `Iterable` and dates, such as easy filtering and transformations.
- **Utility Functions**: Helpers for HTTP communication, datetime operations, file system access, native feature handling, and confirmation dialogs.
- **Widgets**: Reusable components like a configurable `LoadingBuilder`, updatable notification widgets, and a three-state selection widget.
- **Routing**: Useful routing configuration structures and path-joining utilities.

## Getting started

Include `nanna` in your `pubspec.yaml`:

```yaml
dependencies:
  nanna: ^1.0.0
```

And import it in your Dart files:

```dart
import 'package:nanna/nanna.dart';
```

## Usage

### Notifications
Easily show success, error, or custom notifications:
```dart
naShowNotification(
  context : context,
  type    : ToastificationType.success,
  title   : 'Success!',
  subtitle: 'Operation completed successfully.',
);

naShowNotificationException(
  context: context,
  title  : 'Error Occurred',
  error  : exception,
);
```

### Secure Storage
Initialize and use secure storage effortlessly:
```dart
// Initialize at app start
naSecureStorageInit();

// Write and read
await naSecureStorageWriteBoolAsync('isFirstLaunch', false);
bool isFirstLaunch = await naSecureStorageReadBoolAsync('isFirstLaunch') ?? true;
```

## Custom Formatting Scripts

This repository contains custom Dart scripts to enforce a specific code style that the official `dart format` does not support. 
By importing `nanna` in your project, you can run these formatting scripts directly via `dart run`.

> **⚠️ IMPORTANT**: To prevent your editor from destroying the custom formatting on save, ensure that `"editor.formatOnSave": false` is set for `[dart]` in your `.vscode/settings.json`.

### 1. Vertical Alignment
To vertically align named parameters (colons) and ternary operators in your widgets, use `format_alignment`:

```bash
# Run on the default 'lib' folder
dart run nanna:format-alignment

# Run on a specific folder
dart run nanna:format-alignment lib/src/widgets
```

### 2. Import Sorting by Length
To sort your Dart imports by string length (shortest to longest) grouped by `dart:`, `package:`, and local imports, use `format_imports`:

```bash
# Run on the default 'lib' folder
dart run nanna:format-imports

# Run on a specific folder
dart run nanna:format-imports lib/src/models
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
