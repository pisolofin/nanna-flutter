<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.

## Custom Formatting Scripts

This repository contains custom Dart scripts to enforce a specific code style that the official `dart format` does not support. These scripts are located in the `scripts/` directory.

> **⚠️ IMPORTANT**: To prevent your editor from destroying the custom formatting on save, ensure that `"editor.formatOnSave": false` is set for `[dart]` in your `.vscode/settings.json`.

### 1. Vertical Alignment
To vertically align named parameters (colons) and ternary operators in your widgets, use `format_alignment.dart`:

```bash
# Run on the default 'lib' folder
dart scripts/format_alignment.dart

# Run on a specific folder
dart scripts/format_alignment.dart lib/src/widgets
```

### 2. Import Sorting by Length
To sort your Dart imports by string length (shortest to longest) grouped by `dart:`, `package:`, and local imports, use `format_imports.dart`:

```bash
# Run on the default 'lib' folder
dart scripts/format_imports.dart

# Run on a specific folder
dart scripts/format_imports.dart lib/src/models
```
