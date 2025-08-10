import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/app/app.router.dart';
import 'package:flutter_base/services/analytics/analytics_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final analytic = locator<AnalyticsService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));
    await analytic.performAction('AppStartup');

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    await _navigationService.replaceWithHomeView();
  }
}
