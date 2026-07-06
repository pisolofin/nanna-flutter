# Development Guidelines & Constraints

This document outlines the technical constraints, architectural decisions, and specific coding rules to be followed during the development of the Walked app.

## Target Platforms
- **Primary:** iOS and Android.
- **Secondary (Postponed):** Web support will be developed in a later phase.

## Architecture & Storage
- **Offline-First:** All data (trips, POIs, notes, toggles) must be saved locally on the device first. The app must be fully functional without an internet connection.
- **Synchronization:** The app will sync with a remote server. The server-side implementation is postponed, but the local data models and architecture must be designed to support eventual synchronization.

## Dependencies
- The project relies on a custom local framework. It must be included in `pubspec.yaml` as follows:
  ```yaml
  dependencies:
    nanna_flutter:
      path: ../nanna/nanna-flutter
  ```

## Coding Styles & Rules (Dart/Flutter)
*   **Naming (Variables and Methods):**
    *   Strict English naming. Highly descriptive. No single-letter variables.
    *   Variables representing lists/arrays must be singular and end with `List` (e.g., `userList`, not `users`).
    *   Asynchronous methods must have the `Async` suffix (e.g., `fetchDataAsync()`).
*   **Syntax and Formatting:**
    *   Mandatory use of curly braces `{}` for all `if`, `for`, and `while` blocks, with no exceptions for single-line blocks.
    *   No spaces before structural keywords if preceded by a closing brace (e.g., `}else` and `}catch`, not `} else`).
    *   Line length limits are flexible (can exceed 80 characters).
    *   **Named Parameters Alignment:** When passing multiple named parameters to functions or constructors (e.g., UI widgets), their colons (`:`) must be vertically aligned using spaces to improve readability.
*   **Class Properties:** Explicitly use the `this.` prefix to refer to public class properties. Do **NOT** use `this.` for private variables or methods (those starting with `_`).
*   **Comments & Code Structure:** All code comments must be written in English. Always add comments to important classes and functions, regardless of whether they are public or private. Separate long code blocks with important comments explaining what will be done. If a function or widget is too long, extract parts into private functions.
*   **No Magic Values:** Never use magic strings or magic numbers in the UI. Always use the localization system (`AppLocalizations`) for text and centralized constants (in `lib/constants/`) for padding, sizes, and colors.
*   **Imports:**
    *   Default UI import should be `import 'package:flutter/widgets.dart';` (avoid `material.dart` or `cupertino.dart` unless strictly necessary).
    *   Order of imports (separated by empty lines):
        1. `import 'dart:...'`
        2. `import 'package:...'`
        3. Local project imports.
    *   Within each group, sort imports by line length.
*   **Flutter Specifics:**
    *   Constructors: always use `this.propertyName` in the signature.
    *   State Widgets: inside `State` classes, access the widget properties using `widget` (NOT `this.widget`).
    *   Futures: omit the generic void, use `Future` instead of `Future<void>`.
*   **Project Structure (Strict Folders):**
    *   `pages/` (App screens). Group by domain/entity (e.g., `/pages/trip/trip.page.dart`, `/pages/trip/trip-create.page.dart`). Must follow the pattern: `/pages/domain/domain.page.dart` (Scaffold only) and `/pages/domain/widgets/domain.widget.dart` (Body content).
    *   `services/` (Business logic and APIs)
    *   `widgets/` (Reusable UI components)
    *   `database/` (Local data management)
*   **File Naming:** File names must strictly use kebab-case (`-`), never underscores (`_`). Example: `home-page.dart`.
