import 'package:stacked/stacked_annotations.dart';

import 'constants.dart';

// **************************************************************************
/// This class is used to manage feature flags in the application.
/// Features are defined in a central map and represented by enums.
/// To enable or disable a feature, add it to the map and define it in the `FeatureType` enum.
/// Use the `lookForFeature` method to check whether a feature is enabled for the current environment.
/// Additionally, you can extend this class to support updating feature flags from a remote data source
/// to toggle features dynamically at runtime.
// **************************************************************************

/// Enum for feature flags
enum FeatureType {
  firebaseAnalyticsFeature,
}

/// Map string keys to feature types
const Map<String, FeatureType> featureNames = {
  'firebaseAnalytics': FeatureType.firebaseAnalyticsFeature,
};

/// A single map holding features for all environments
final Map<String, Map<FeatureType, String?>> _featuresByEnv = {
  Environment.dev: {
    FeatureType.firebaseAnalyticsFeature: '/',
  },
  Environment.prod: {
    FeatureType.firebaseAnalyticsFeature: '/',
  },
  Environment.test: {
    FeatureType.firebaseAnalyticsFeature: null,
  },
};

/// Feature flag manager class
class FeatureFlag {
  /// Get the feature value for current environment
  String? lookForFeature(FeatureType feature) {
    return _featuresByEnv[AppConstants.currentEnvironment]?[feature];
  }

  /// Set/update a feature dynamically
  void setFeature({
    FeatureType? feature,
    String? featureName,
    String? value,
  }) {
    // Convert name to enum if needed
    feature ??= featureNames[featureName ?? ''];
    if (feature == null) return;

    _featuresByEnv[AppConstants.currentEnvironment]?[feature] = value;
  }
}
