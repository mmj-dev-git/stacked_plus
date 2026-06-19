# Stacked Plus

A Flutter starter project built on
[Stacked](https://stacked.filledstacks.com/docs/getting-started/overview).
It includes the base architecture, routing, dependency injection, startup
logic, Firebase hooks, analytics, localization, shared preferences,
connectivity handling, flavors, linting, tests, and development scripts needed
to start a production app with less setup work.

For the project-specific startup flow, read
[docs/stacked-startup-logic.md](docs/stacked-startup-logic.md).

## Quick Start

Use this path when setting up the project for the first time.

```powershell
# 1. Check Flutter is available
flutter --version
flutter doctor

# 2. Install FVM if it is not already installed
dart pub global activate fvm

# 3. Install the Flutter SDK version from .fvmrc
fvm install

# 4. Install Melos if it is not already installed
dart pub global activate melos

# 5. Install dependencies and Git hooks
melos run init

# 6. Generate localization, routes, locator, mocks, and other generated code
melos run generate

# 7. Run analyzer and tests
melos run analyze
melos run test
```

If `dart` is not recognized on Windows, add the Flutter SDK `bin` directory to
your `PATH`, then restart the terminal. The Flutter SDK provides both
`flutter` and `dart`.

As a temporary fallback, use Flutter commands directly:

```powershell
flutter pub get
flutter pub global activate fvm
flutter pub global activate melos
```

## Running The App

This project has three flavor entrypoints:

| Environment | Dart entrypoint | Native flavor | Melos command |
| --- | --- | --- | --- |
| Test | `lib/main_test.dart` | `fortest` | `melos run run:test` |
| Development | `lib/main_dev.dart` | `development` | `melos run run:dev` |
| Production | `lib/main_prod.dart` | `production` | `melos run run:prod` |

Equivalent raw Flutter commands:

```powershell
fvm flutter run -t lib/main_test.dart --flavor fortest
fvm flutter run -t lib/main_dev.dart --flavor development
fvm flutter run -t lib/main_prod.dart --flavor production
```

For web:

```powershell
melos run web-run:test
melos run web-run:dev
melos run web-run:prod
```

## Firebase Setup

Firebase is initialized in `lib/app/setup_firebase.dart`.

On mobile, `Firebase.initializeApp()` uses native Firebase config files:

| Platform | Config file |
| --- | --- |
| Android test | `android/app/src/fortest/google-services.json` |
| Android development | `android/app/src/development/google-services.json` |
| Android production | `android/app/src/production/google-services.json` |
| iOS | Add the matching `GoogleService-Info.plist` to the Runner target/scheme |

The Android application IDs are configured in `android/app/build.gradle.kts`:

| Flavor | Application ID |
| --- | --- |
| `production` | `com.example.flutter_base` |
| `development` | `com.example.flutter_base.dev` |
| `fortest` | `com.example.flutter_base.test` |

On web, Firebase requires explicit `FirebaseOptions`. This project reads them
from Dart defines in `lib/app/firebase_config.dart`.

```powershell
fvm flutter run -d chrome -t lib/main_test.dart `
  --dart-define=FIREBASE_API_KEY=your-api-key `
  --dart-define=FIREBASE_APP_ID=your-app-id `
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your-sender-id `
  --dart-define=FIREBASE_PROJECT_ID=your-project-id `
  --dart-define=FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com `
  --dart-define=FIREBASE_STORAGE_BUCKET=your-project.appspot.com `
  --dart-define=FIREBASE_MEASUREMENT_ID=your-measurement-id
```

If the required web values are missing, the app skips Firebase on web and
disables Firebase Analytics for that run. This prevents:

```text
FirebaseOptions cannot be null when creating the default app.
```

## Project Structure

| Path | Purpose |
| --- | --- |
| `lib/main.dart` | Shared app boot sequence used by all flavors |
| `lib/main_dev.dart` | Development flavor entrypoint |
| `lib/main_test.dart` | Test flavor entrypoint |
| `lib/main_prod.dart` | Production flavor entrypoint |
| `lib/app/app.dart` | Stacked annotations for routes, services, dialogs, and sheets |
| `lib/app/app.locator.dart` | Generated service locator |
| `lib/app/app.router.dart` | Generated router |
| `lib/app/app.dialogs.dart` | Generated dialog setup |
| `lib/app/app.bottomsheets.dart` | Generated bottom sheet setup |
| `lib/ui/views` | Screens and ViewModels |
| `lib/ui/common` | Shared UI helpers and base widgets |
| `lib/services` | App services registered with Stacked |
| `lib/l10n` | ARB localization source files |
| `lib/generated` | Generated localization output |
| `test/helpers` | Test service registration and generated mocks |
| `docs` | Project-specific documentation |

Generated files should not be edited by hand. Update the source annotations or
ARB files, then regenerate.

## Stacked Workflow

Use `lib/app/app.dart` as the source of truth for Stacked setup.

When adding a new route, service, dialog, or bottom sheet:

1. Add the class in the correct project folder.
2. Register it in `lib/app/app.dart`.
3. Run code generation.

```powershell
melos run generate
```

The same command runs:

```powershell
fvm dart run intl_utils:generate
fvm dart run build_runner build --delete-conflicting-outputs
```

If you use the Stacked CLI:

```powershell
dart pub global activate stacked_cli
stacked create view login
stacked create service authentication
melos run generate
```

## Startup Flow

Boot order:

1. `main_dev.dart`, `main_test.dart`, or `main_prod.dart` sets `FlavorConfig`.
2. `mainApp()` in `lib/main.dart` initializes Flutter bindings.
3. Stacked locator, dialogs, and bottom sheets are set up.
4. `ConnectivityService` starts listening for connectivity changes.
5. Firebase is initialized when config is available.
6. `AnalyticsService` creates enabled integrations.
7. `MaterialApp` starts at `Routes.startupView`.
8. `StartupViewModel.runStartupLogic()` performs app startup decisions.
9. Navigation replaces startup with `HomeView`.

Keep infrastructure setup in `mainApp()`. Put user-facing startup decisions,
such as auth checks, onboarding checks, cached settings, or redirect logic, in
`StartupViewModel.runStartupLogic()`.

## Services

Services are registered in `lib/app/app.dart` and accessed through the Stacked
locator.

```dart
final preferences = locator<SharedPreferencesService>();
await preferences.put('themeMode', 'dark');
final themeMode = await preferences.getString('themeMode');
```

Available project services:

| Service | File | Purpose |
| --- | --- | --- |
| `AnalyticsService` | `lib/services/analytics/analytics_service.dart` | Analytics abstraction with Firebase adapter support |
| `ConnectivityService` | `lib/services/connectivity/connectivity_service.dart` | Tracks online/offline state |
| `SharedPreferencesService` | `lib/services/shared_preferences/shared_preferences_service.dart` | Typed wrapper around `shared_preferences` |
| `FeatureFlag` | `lib/common/feature_flags.dart` | Environment-aware feature flags |

`DgBaseView` in `lib/ui/common/base_view.dart` uses `ConnectivityService` to
show a no-internet banner by default. Disable it per screen when needed:

```dart
DgBaseView(
  showConnectivityBanner: false,
  child: YourContent(),
);
```

## Localization

Source strings live in `lib/l10n/*.arb`.

After editing ARB files, regenerate:

```powershell
melos run strings
```

The generated localization class is imported as:

```dart
import 'package:flutter_base/generated/l10n.dart';
```

## Quality Checks

Run these before opening a pull request or sharing the project:

```powershell
fvm dart format lib test
melos run analyze
melos run test
melos run test:golden
```

Update golden files only when the UI change is intentional:

```powershell
melos run update:golden
```

The analyzer configuration is in `analysis_options.yaml` and uses
`total_lints`.

## Useful Commands

| Command | Purpose |
| --- | --- |
| `melos run init` | Install dependencies and Git hooks |
| `melos run generate` | Generate localization and Stacked code |
| `melos run strings` | Generate localization only |
| `melos run analyze` | Run Flutter analyzer |
| `melos run test` | Run unit and widget tests |
| `melos run test:golden` | Run golden tests |
| `melos run update:golden` | Update golden snapshots |
| `melos run clear-cache` | Clean build runner cache |
| `melos run generate-launcher-icon` | Generate launcher icons |

## Common Troubleshooting

### `dart` is not recognized

Add Flutter's `bin` directory to the Windows `PATH`. Check with:

```powershell
where flutter
where dart
```

If `flutter` works but `dart` does not, restart the terminal after updating
`PATH`, or use `flutter pub ...` commands temporarily.

### Firebase Web Options Are Missing

Use the Dart defines shown in the Firebase section. Without them, Firebase is
skipped on web by design.

### Generated Files Are Out Of Date

Run:

```powershell
melos run generate
```

This fixes most missing route, locator, mock, and localization outputs.

### Build Runner Has Conflicts

Run:

```powershell
melos run clear-cache
melos run generate
```

## Included Libraries

| Area | Libraries |
| --- | --- |
| Architecture | `stacked`, `stacked_services`, `stacked_generator` |
| Firebase | `firebase_core`, `firebase_analytics`, `firebase_crashlytics` |
| Environments | `flutter_flavor`, `device_preview` |
| Data | `hive`, `hive_flutter`, `shared_preferences` |
| Connectivity | `connectivity_plus` |
| Localization | `intl`, `intl_utils`, `flutter_localizations` |
| Models and codegen | `freezed`, `freezed_annotation`, `build_runner` |
| Testing | `flutter_test`, `mockito`, `golden_toolkit`, `network_image_mock` |
| Workflow | `fvm`, `melos`, `husky`, `total_lints`, `flutter_launcher_icons` |

## Before Building A Real App

Update these project defaults:

1. Rename the app package in `pubspec.yaml` if `flutter_base` is not the final
   package name.
2. Update Android `namespace` and `applicationId` in
   `android/app/build.gradle.kts`.
3. Update iOS bundle IDs in Xcode.
4. Replace Firebase config files for each flavor.
5. Replace launcher icons in `assets/images` and regenerate icons.
6. Review feature flags in `lib/common/feature_flags.dart`.
