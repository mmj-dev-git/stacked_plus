import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/app/app.router.dart';
import 'package:flutter_base/ui/views/startup/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('StartupViewModelTest -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    test(
      'runStartupLogic tracks startup and replaces startup with home',
      () async {
        final navigationService = getAndRegisterNavigationService();
        final analyticsService = getAndRegisterAnalyticsServiceService();
        final model = StartupViewModel(startupDelay: Duration.zero);

        await model.runStartupLogic();

        verify(analyticsService.performAction('AppStartup')).called(1);
        verify(
          navigationService.replaceWith<dynamic>(Routes.homeView),
        ).called(1);
      },
    );
  });
}
