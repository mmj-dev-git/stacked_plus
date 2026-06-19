import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/app/app.bottomsheets.dart';
import 'package:flutter_base/app/app.dialogs.dart';
import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/app/app.router.dart';
import 'package:flutter_base/app/setup_firebase.dart';
import 'package:flutter_base/common/feature_flags.dart';
import 'package:flutter_base/services/analytics/analytics_service.dart';
import 'package:flutter_base/services/connectivity/connectivity_service.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'common/constants.dart';
import 'generated/l10n.dart';

Future<void> mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConstants.currentEnvironment =
      FlavorConfig.instance.variables['env'] as String? ?? Environment.test;
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  await locator<ConnectivityService>().initialise();
  // Initialize Firebase and configure Crashlytics
  final firebaseReady = await setupFirebase();
  if (!firebaseReady) {
    locator<FeatureFlag>().setFeature(
      feature: FeatureType.firebaseAnalyticsFeature,
    );
  }
  // Initialize and configure Analytics
  await locator<AnalyticsService>().createIntegrations();

  runApp(
    DevicePreview(
      enabled: kIsWeb && AppConstants.currentEnvironment == Environment.test,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   //Add more supported Locale here
      // ],
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
    );
  }
}
