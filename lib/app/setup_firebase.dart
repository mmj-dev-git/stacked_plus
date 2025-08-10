import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Capture Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    // Log to console for debugging
    FlutterError.dumpErrorToConsole(errorDetails);
    // Send to Crashlytics
    unawaited(
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails),
    );
  };

  // Capture uncaught async errors outside Flutter framework
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    unawaited(
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
    );
    return true; // prevent default handler from running
  };
}
