import 'package:flutter_base/app/app.bottomsheets.dart';
import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_base/ui/common/app_strings.dart';
import 'package:flutter_base/ui/views/home/home_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    group('incrementCounter -', () {
      test('When called once should return  Counter is: 1', () {
        final model = getModel();
        model.incrementCounter();
        expect(model.counterLabel, 'Counter is: 1');
      });
    });

    group('showBottomSheet -', () {
      test(
        'When called, should show custom bottom sheet using notice variant',
        () async {
          final bottomSheetService = getAndRegisterBottomSheetService();

          final model = getModel();
          await model.showBottomSheet();
          verify(
            bottomSheetService.showCustomSheet(
              variant: BottomSheetType.notice,
              title: ksHomeBottomSheetTitle,
              description: ksHomeBottomSheetDescription,
            ),
          );
        },
      );
    });
  });
}
