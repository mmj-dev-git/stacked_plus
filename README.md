# Stacked_plus [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A Flutter project built on the [Stacked](https://pub.dev/packages/stacked) framework — a powerful architecture solution for production-ready applications.

Stacked provides amazing solutions for dependency injection, state management, routing, and more. However, there are some must-have libraries that are incredibly handy in development and ones we use daily when building high-quality apps.

**Stacked_plus** includes these core libraries so you can get started building your next app quickly, without wasting time on setting up the base project structure.

More details about Stacked can be found here: [Stacked Documentation](https://stacked.filledstacks.com/docs/getting-started/overview)

---

## Included Libraries & Purpose

### 📦 Project Management & Workflow
| Library | Purpose | Link |
|---------|---------|------|
| **Melos** | Manage multi-package Flutter/Dart projects efficiently. See [`melos.yaml`](./melos.yaml) for available commands. | [melos.invertase.dev](https://melos.invertase.dev/) |
| **FVM** | Flutter Version Manager for consistent Flutter SDK usage across teams. | [fvm.app](https://fvm.app/) |
| **Husky** | Git hooks to run checks and scripts before commits or pushes. | [typicode.github.io/husky](https://typicode.github.io/husky) |
| **total_lints** | Standardized lints for cleaner, maintainable code. | [pub.dev/packages/total_lints](https://pub.dev/packages/total_lints) |

---

### 🌍 Localization & Multi-Environment
| Library | Purpose | Link |
|---------|---------|------|
| **DevicePreview** | Preview and test your app on multiple devices & resolutions. | [pub.dev/packages/device_preview](https://pub.dev/packages/device_preview) |
| **flutter_flavor** | Set up multiple app flavors (test/dev/prod) with **3 Google JSON** configs. | [pub.dev/packages/flutter_flavor](https://pub.dev/packages/flutter_flavor) |
| **intl_utils** | Generate localization code from `.arb` files. | [pub.dev/packages/intl_utils](https://pub.dev/packages/intl_utils) |
| **flutter_localizations** | Flutter’s built-in localization support. | [api.flutter.dev/flutter/flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) |

---

### 🔥 Firebase Integration
| Library | Purpose | Link |
|---------|---------|------|
| **firebase_analytics** | Track user engagement and events. Setup with `flutterfire configure`. | [firebase.google.com/docs/analytics](https://firebase.google.com/docs/analytics/get-started?platform=flutter) |
| **firebase_crashlytics** | Capture and report app crashes in real-time. | [firebase.google.com/docs/crashlytics](https://firebase.google.com/docs/crashlytics) |

---

### 🗂 State Management & Data
| Library | Purpose | Link |
|---------|---------|------|
| **freezed_annotation** | Immutable classes & union types for safer state management. | [pub.dev/packages/freezed_annotation](https://pub.dev/packages/freezed_annotation) |
| **hive** | Lightweight, fast, NoSQL database for Flutter. | [pub.dev/packages/hive](https://pub.dev/packages/hive) |

---

### 🛠 Utilities
| Library | Purpose | Link |
|---------|---------|------|
| **logger** | Simple, colorful, and formatted logging. | [pub.dev/packages/logger](https://pub.dev/packages/logger) |
| **flutter_launcher_icons** | Easily generate app launcher icons. | [pub.dev/packages/flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) |
| **form_validation** | Simplify form field validations. | [pub.dev/packages/form_validation](https://pub.dev/packages/form_validation) |

---

With **Stacked_plus**, you get a ready-to-use foundation that combines the power of Stacked with essential tools and libraries for building robust, scalable, and production-ready Flutter apps.

## 🚀 Quick Start

Add google-services in android/add

This project uses **Melos** for managing packages and development scripts.  
Make sure you have [Melos installed](https://melos.invertase.dev/getting-started).

```bash
# Install Melos globally
dart pub global activate melos

# Install Flutter versions with FVM
fvm install 3.*.*

# Install dependencies & enable Git hooks
melos run init

#Install Husky
npm install husky --save-dev
Or
yarn add husky --dev

#Enable Enable Git hooks
npx husky install

# Run code generation
melos generate

# Run the app
fvm flutter run
