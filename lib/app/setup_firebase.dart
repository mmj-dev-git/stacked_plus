import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_config.dart';

Future<bool> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = FirebaseConfig.currentPlatform;
  if (kIsWeb && options == null) {
    debugPrint(
      'Skipping Firebase initialization on web. Provide Firebase web options '
      'with --dart-define values to enable Firebase.',
    );
    return false;
  }

  try {
    await Firebase.initializeApp(options: options);
  } on FirebaseException catch (error) {
    debugPrint('Skipping Firebase initialization: ${error.message}');
    return false;
  }

  if (kIsWeb) {
    return true;
  }

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

  return true;
}
