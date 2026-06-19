import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/app/app.router.dart';
import 'package:flutter_base/services/analytics/analytics_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  StartupViewModel({this.startupDelay = const Duration(seconds: 3)});

  final _navigationService = locator<NavigationService>();
  final _analyticsService = locator<AnalyticsService>();
  final Duration startupDelay;

  // Place anything here that needs to happen before we get into the application
  Future<void> runStartupLogic() async {
    await Future<void>.delayed(startupDelay);
    await _analyticsService.performAction('AppStartup');

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    await _navigationService.replaceWithHomeView();
  }
}
