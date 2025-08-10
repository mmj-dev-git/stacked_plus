import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_event.freezed.dart';

@freezed
abstract class AnalyticsEvent with _$AnalyticsEvent {
  const factory AnalyticsEvent({
    required String eventName,
    Map<String, Object>? params,
  }) = _AnalyticsEvent;
}
