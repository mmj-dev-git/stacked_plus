# Stacked Startup Logic In This Project

This project uses the Stacked startup pattern described in the official
[Stacked Startup Logic](https://stacked.filledstacks.com/docs/getting-started/startup-logic/)
documentation. The startup view is the first Flutter route after the native
splash screen, and its ViewModel is the place for app boot decisions before the
user lands in the real app.

## What Stacked Provides

The official Stacked docs describe a default app setup that includes state
management, startup logic, navigation, dialog builders, bottom sheet builders,
dependency inversion, logging, and unit-test examples. In this project those
pieces live in:

| Concern | Project file |
| --- | --- |
| Stacked app annotations | `lib/app/app.dart` |
| Generated service locator | `lib/app/app.locator.dart` |
| Generated routes and navigation helpers | `lib/app/app.router.dart` |
| Dialog registration | `lib/app/app.dialogs.dart` |
| Bottom sheet registration | `lib/app/app.bottomsheets.dart` |
| Startup loading UI | `lib/ui/views/startup/startup_view.dart` |
| Startup decision logic | `lib/ui/views/startup/startup_viewmodel.dart` |

## Current Boot Flow

1. Flavor entrypoints such as `lib/main_dev.dart`, `lib/main_test.dart`, and
   `lib/main_prod.dart` configure `FlavorConfig`.
2. `mainApp()` in `lib/main.dart` ensures Flutter is initialized, sets up the
   Stacked locator, registers dialogs and bottom sheets, initializes Firebase,
   creates analytics integrations, stores the active environment, then runs the
   app.
3. `MaterialApp` starts at `Routes.startupView`.
4. `StartupView` renders the loading UI.
5. `onViewModelReady` schedules `StartupViewModel.runStartupLogic()` after the
   first frame.
6. `runStartupLogic()` waits for the startup delay, tracks the `AppStartup`
   analytics event, then replaces the startup route with `HomeView`.

The project uses `replaceWithHomeView()` instead of `navigateToHomeView()` so
the user cannot navigate back to the startup/loading screen.

## Where To Add Real Startup Decisions

Keep app-wide infrastructure that must exist before any UI in `mainApp()`.
Examples in this project are locator setup, dialog/bottom-sheet setup,
Firebase, analytics integration creation, and environment selection.

Put user-facing boot decisions in `StartupViewModel.runStartupLogic()`.
Examples:

- Check an authentication service and route to home or login.
- Load local persisted settings.
- Decide whether onboarding must be shown.
- Track startup analytics once required services are ready.

A typical auth-based startup flow would look like:

```dart
Future<void> runStartupLogic() async {
  await _analyticsService.performAction('AppStartup');

  if (_authenticationService.userLoggedIn()) {
    await _navigationService.replaceWithHomeView();
  } else {
    await _navigationService.replaceWithLoginView();
  }
}
```

To add that flow, create the service and view with the Stacked CLI, register the
service and route in `lib/app/app.dart`, then regenerate Stacked code:

```bash
stacked create service authentication
stacked create view login
stacked generate
```

If the CLI is not available in a local environment, the project already has
`build_runner` and `stacked_generator`, so the generator can also be run through
the existing Melos script or with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Testing Startup Logic

`StartupViewModel` accepts an optional `startupDelay` so production can keep the
loading pause while unit tests use `Duration.zero`. The startup behavior is
covered in `test/viewmodels/startup_viewmodel_test.dart`, which verifies that
startup analytics are tracked and navigation replaces the startup route with
home.

