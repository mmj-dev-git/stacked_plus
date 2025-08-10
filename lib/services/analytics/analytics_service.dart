import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/common/common_functions.dart';
import 'package:flutter_base/common/constants.dart';
import 'package:flutter_base/common/events.dart';
import 'package:flutter_base/common/feature_flags.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'analytics_event.dart';
import 'analytics_integration.dart';
import 'firebase_analytics_adapter.dart';

class AnalyticsService with ListenableServiceMixin {
  late FirebaseAnalyticsAdapter? _firebaseAnalyticsAdapter;
  final FeatureFlag _flags = locator<FeatureFlag>();
  final Set<AnalyticsIntegration> _integrations = {};
  bool _ready = false;

  bool get ready => _ready;

  bool _isCreationInProgress = false;

  Future<void> createIntegrations() async {
    if (_ready || _isCreationInProgress) {
      return;
    }

    _isCreationInProgress = true;
    _integrations.clear();
    if (_flags.lookForFeature(FeatureType.firebaseAnalyticsFeature) != null) {
      _firebaseAnalyticsAdapter = FirebaseAnalyticsAdapter();
      _integrations.add(_firebaseAnalyticsAdapter!);
    }

    // Add other integrations here based on other feature flags
    _ready = true;
    _isCreationInProgress = false;
  }

  /// Tracks a custom event or user action in analytics integrations.
  ///
  /// This is a generic method for recording various events and actions
  /// performed by the user within the app, such as button clicks, form
  /// submissions, or any other custom events you want to track.
  ///
  /// It supports multiple analytics platforms like Firebase, Google Analytics,
  /// or any other integrated service.
  ///
  /// The [eventName] parameter specifies the name of the event or action
  /// being tracked. This should be a descriptive name that clearly identifies
  /// the event.
  ///
  /// The optional [params] parameter allows you to include additional data
  /// relevant to the event, providing further context for analysis.
  ///
  /// **Example Usage:**
  /// ```dart
  /// // Records clicks on the Show/Hide button on the Enter Pin screen from the login screen
  /// performAction('login_enter_pin_eye_click', {'show_pin': 'true'});
  Future<void> performAction(
    String eventName, [
    Map<String, Object>? params,
  ]) async {
    if (!_ready) await createIntegrations();
    if (_integrations.isNotEmpty &&
        AppConstants.currentEnvironment != Environment.test) {
      final eventParams = await _addContextualParams(params);

      for (final integration in _integrations) {
        await integration.performAction(
          AnalyticsEvent(eventName: eventName, params: eventParams),
        );
      }
    }
  }

  Future<void> removeUserId() async {
    if (AppConstants.currentEnvironment == Environment.test) {
      return;
    }

    if (_integrations.isNotEmpty) {
      for (final integration in _integrations) {
        await integration.removeUserId();
      }
    }
  }

  /// Sets the user ID for analytics tracking.
  ///
  /// This method associates a unique identifier with the user, allowing you
  /// to track user behavior and engagement across sessions and platforms.
  ///
  /// The [id] parameter specifies the unique identifier for the user.
  /// This is UUID that we use as a unique identifier.
  ///
  /// **Note:** This method does not set the user ID in the test environment
  /// to avoid polluting test data.
  Future<void> setUserId(String id) async {
    if (AppConstants.currentEnvironment == Environment.test) {
      return;
    }

    if (!_ready) await createIntegrations();
    if (_integrations.isNotEmpty) {
      for (final integration in _integrations) {
        await integration.setUserId(id);
      }
    }

    // Update User Properties
    await _setUserProperties();
  }

  /// Sets a user property to a given value.
  ///
  /// User property count is limited. Make sure to cheeck the Firebase, Adjust, MixPanel etc documentation.
  /// Once set, user property values persist throughout the app lifecycle and across sessions.
  ///
  /// Setting a null [value] removes the user property.
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (AppConstants.currentEnvironment == Environment.test) {
      return;
    }

    if (!_ready) await createIntegrations();
    if (_integrations.isNotEmpty) {
      for (final integration in _integrations) {
        await integration.setUserProperty(name: name, value: value);
      }
    }
  }

  /// Tracks a screen view event in analytics integrations.
  ///
  /// This method records when a user views a screen within the app,
  /// allowing you to analyze user navigation and behavior across different
  /// screens. It supports various analytics platforms like Firebase or
  /// any other integrated service.
  ///
  /// The [screenClass] parameter specifies the class or category of the screen,
  /// providing a high-level grouping for analysis.
  ///
  /// The [screenName] parameter provides the specific name or identifier of
  /// the screen being viewed.
  ///
  /// The [viewName] parameter captures the name of the view or component
  /// within the screen that the user is interacting with.
  ///
  /// The optional [params] parameter allows you to include additional data
  /// relevant to the screen view event, such as user actions or screen
  /// specific information.
  ///
  /// **Example Usage:**

  /// trackScreenView(
  ///   screenClass: 'Settings',
  ///   screenName: 'general_settings_screen',
  ///   viewName: 'app_settings_view',
  /// );
  Future<void> trackScreenView({
    required String? screenClass,
    required String screenName,
    required String viewName,
    Map<String, Object>? params,
  }) async {
    if (!_ready) await createIntegrations();

    if (AppConstants.currentEnvironment == Environment.test) {
      return;
    }

    // Add Contextual Prameters
    final eventParams = await _addContextualParams(params);

    // Add Essential Parameters
    eventParams[AnalyticsParams.viewName] = viewName;

    if (_integrations.isNotEmpty) {
      for (final integration in _integrations) {
        await integration.trackScreenView(
          screenClass: screenClass,
          screenName: screenName,
          params: eventParams,
        );
      }
    }
  }

  Future<Map<String, Object>> _addContextualParams(
    Map<String, Object>? params,
  ) async {
    final eventParams = params ?? <String, Object>{};

    // Add Contextual Prameters to eventParams (if needed)

    return eventParams;
  }

  /// Sets user properties for Firebase Analytics, providing context about the app and user environment.
  /// 25 distinct user property names per project.
  ///
  /// This function retrieves app-related information (app name, package name, version,
  /// platform, installer store) and user-related details (language, build mode,
  /// environment, app flavor) and sets them as user properties in Firebase Analytics.
  ///
  /// User properties are persistent attributes that describe segments of your user base,
  /// such as language preference or app version. They are used to understand user behavior
  /// and create targeted audiences for analysis and campaigns.
  ///
  /// The function uses `unawaited` to avoid blocking the execution of the function while
  /// setting the user properties, as these operations don't require immediate feedback.
  Future<void> _setUserProperties() async {
    final packageInfo = await PackageInfo.fromPlatform();
    unawaited(
      setUserProperty(
        name: AnalyticsParams.appName,
        value: packageInfo.appName,
      ),
    );

    unawaited(
      setUserProperty(
        name: AnalyticsParams.packageName,
        value: packageInfo.packageName,
      ),
    );
    unawaited(
      setUserProperty(
        name: AnalyticsParams.appVersion,
        value: packageInfo.version,
      ),
    );

    unawaited(
      setUserProperty(
        name: AnalyticsParams.platform,
        value: getPlatform(),
      ),
    );

    if (packageInfo.installerStore != null &&
        packageInfo.installerStore!.isNotEmpty) {
      unawaited(
        setUserProperty(
          name: AnalyticsParams.installerStore,
          value: packageInfo.installerStore!,
        ),
      );
    }

    unawaited(
      setUserProperty(
        name: AnalyticsParams.buildMode,
        value: kDebugMode ? 'debug' : 'release',
      ),
    );
    unawaited(
      setUserProperty(
        name: AnalyticsParams.appFlavor,
        value: AppConstants.currentEnvironment,
      ),
    );
  }
}
