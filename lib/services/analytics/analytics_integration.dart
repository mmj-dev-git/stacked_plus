import 'dart:async';
import 'analytics_event.dart';

abstract class AnalyticsIntegration {
  void init();

  /// Sets the user ID property.
  ///
  Future<void> setUserId(String id);

  /// Sets a user property to a given value.
  ///
  /// User property count is limited. Make sure to check the Firebase, Adjust, MixPanel etc documentation.
  /// Once set, user property values persist throughout the app lifecycle and across sessions.
  ///
  /// Setting a null [value] removes the user property.
  Future<void> setUserProperty({
    required String name,
    required String value,
  });

  /// Removes the user ID property.
  ///
  Future<void> removeUserId();

  /// User this method to log a custom event
  ///
  Future<void> performAction(AnalyticsEvent event);

  /// Logs the standard screen tracking event.
  ///
  /// This event signifies a screen view. Use this when a screen transition occurs.
  Future<void> trackScreenView({
    String? screenClass,
    String? screenName,
    String? viewName,
    Map<String, Object>? params,
  });
}
