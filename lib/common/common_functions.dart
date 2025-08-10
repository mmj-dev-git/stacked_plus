import 'dart:io';

import 'package:flutter/foundation.dart';

String getPlatform() {
  if (kIsWeb) {
    return 'web';
  } else if (Platform.isIOS) {
    return 'ios';
  } else if (Platform.isAndroid) {
    return 'android';
  } else {
    return 'unknown'; // For other platforms
  }
}
