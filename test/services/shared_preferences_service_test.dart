import 'package:flutter_base/services/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesServiceTest -', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('put stores supported values and get returns them', () async {
      final service = SharedPreferencesService();

      await service.put('name', 'stacked');
      await service.put('counter', 7);
      await service.put('enabled', true);
      await service.put('ratio', 1.5);
      await service.put('tags', <String>['flutter', 'stacked']);

      expect(await service.get('name'), 'stacked');
      expect(await service.getInt('counter'), 7);
      expect(await service.getBool('enabled'), true);
      expect(await service.getDouble('ratio'), 1.5);
      expect(await service.getStringList('tags'), ['flutter', 'stacked']);
    });

    test('remove deletes a stored value', () async {
      final service = SharedPreferencesService();

      await service.put('token', 'abc');
      expect(await service.containsKey('token'), true);

      await service.remove('token');

      expect(await service.containsKey('token'), false);
      expect(await service.getString('token'), isNull);
    });
  });
}
