import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:stacked/stacked_annotations.dart';

import 'main.dart';

void main() async {
  FlavorConfig(
    name: 'DEV',
    color: Colors.blue,
    location: BannerLocation.bottomStart,
    variables: {
      'env': Environment.dev,
    },
  );

  await mainApp();
}
