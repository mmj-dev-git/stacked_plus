import 'dart:async';

import 'package:flutter_base/services/connectivity/connectivity_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityServiceTest -', () {
    test('initialise stores the current connectivity status', () async {
      final service = ConnectivityService(
        checkConnectivity: () async => ['ConnectivityResult.none'],
        connectivityStream: const Stream<Object?>.empty(),
      );

      await service.initialise();

      expect(service.isConnected, false);
      await service.dispose();
    });

    test('onConnectionStatusChanged emits when connectivity changes', () async {
      final controller = StreamController<Object?>();
      final service = ConnectivityService(
        checkConnectivity: () async => ['ConnectivityResult.none'],
        connectivityStream: controller.stream,
      );
      final emittedStatuses = <bool>[];

      await service.initialise();
      final subscription = service.onConnectionStatusChanged.listen(
        emittedStatuses.add,
      );

      controller.add(['ConnectivityResult.wifi']);
      await Future<void>.delayed(Duration.zero);

      expect(service.isConnected, true);
      expect(emittedStatuses, [true]);

      await subscription.cancel();
      await service.dispose();
      await controller.close();
    });
  });
}
