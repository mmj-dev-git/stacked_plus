import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_base/app/app.logger.dart';

import 'analytics_event.dart';
import 'analytics_integration.dart';

//FirebaseAnalytics
class FirebaseAnalyticsAdapter implements AnalyticsIntegration {
  final FirebaseAnalytics _firebaseAnalytics;
  final _logger = getLogger('FirebaseAnalyticsAdapter');

  List<String> supportedEvents = [];

  FirebaseAnalyticsAdapter() : _firebaseAnalytics = FirebaseAnalytics.instance;

  @override
  void init() {}

  @override
  Future<void> performAction(AnalyticsEvent event) async {
    try {
      if (supportedEvents.contains(event.eventName) ||
          supportedEvents.isEmpty) {
        final Map<String, Object> parameters = {};
        if (event.params != null) {
          parameters.addEntries(event.params!.entries);
        }
        await _firebaseAnalytics.logEvent(
          name: event.eventName,
          parameters: parameters,
        );
      } else {
        _logger.d(
          'Event ${event.eventName} is not allowed by Firebase Analytics integration',
        );
      }
    } on Exception catch (e) {
      //also catch Exception in case of event is not valid
      _logger.e('An error occurred: $e');
    }
  }

  /// Sets the user ID property.
  ///
  /// Setting a null [id] removes the user id.
  ///
  /// This feature must be used in accordance with [Google's Privacy Policy][1].
  ///
  /// [1]: https://www.google.com/policies/privacy/
  @override
  Future<void> setUserId(String id) async {
    await _firebaseAnalytics.setUserId(id: id);
  }

  @override
  Future<void> removeUserId() async {
    // ignore: avoid_redundant_argument_values
    await _firebaseAnalytics.setUserId(id: null);
  }

  /// Logs the standard `screen_view` event.
  ///
  /// This event signifies a screen view. Use this when a screen transition occurs.
  ///
  /// See: https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics.Event.html#SCREEN_VIEW
  @override
  Future<void> trackScreenView({
    String? screenClass,
    String? screenName,
    String? viewName,
    Map<String, Object>? params,
  }) async {
    await _firebaseAnalytics.logScreenView(
      screenClass: screenClass,
      screenName: screenName,
      parameters: params,
    );
  }

  /// Sets a user property to a given value.
  ///
  /// Up to 25 user property names are supported. Once set, user property
  /// values persist throughout the app lifecycle and across sessions.
  ///
  /// [name] is the name of the user property to set. Should contain 1 to 24
  /// alphanumeric characters or underscores and must start with an alphabetic
  /// character. The "firebase_" prefix is reserved and should not be used for
  /// user property names.
  ///
  /// Setting a null [value] removes the user property.
  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _firebaseAnalytics.setUserProperty(name: name, value: value);
  }
}
