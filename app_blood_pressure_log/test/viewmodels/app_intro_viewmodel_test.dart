import 'package:flutter_test/flutter_test.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AppIntroViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
