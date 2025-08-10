import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:stacked/stacked_annotations.dart';

import 'main.dart';

void main() async {
  FlavorConfig(
    name: '',
    // color: Colors.red,
    // location: BannerLocation.bottomStart,
    variables: {
      'env': Environment.prod,
    },
  );

  await mainApp();
}
