import 'package:flutter_base/app/app.locator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('InfoAlertDialogModel Tests -', () {
    setUp(registerServices);
    tearDown(locator.reset);
  });
}
