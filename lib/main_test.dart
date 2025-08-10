import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:stacked/stacked_annotations.dart';

import 'main.dart';

void main() async {
  FlavorConfig(
    name: 'TEST',
    variables: {
      'env': Environment.test,
    },
  );

  await mainApp();
}
