import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/ui/views/home/home_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'util/golden_toolkit_helper.dart';

void main() {
  setUpAll(setupLocator);
  tearDownAll(locator.reset);

  testGoldens('HomeView - default state', (tester) async {
    await mockNetworkImagesFor(
      () async {
        await tester.pumpDeviceBuilder(
          createGoldenBuilder(
            const HomeView(),
            'home_view_default',
          ),
        );
      },
    );
    await screenMatchesGolden(
      tester,
      'home_view_default',
      customPump: (tester) => tester.pump(const Duration(milliseconds: 100)),
    );
  });
}
