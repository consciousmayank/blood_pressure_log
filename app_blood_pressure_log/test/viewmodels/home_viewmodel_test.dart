import 'package:flutter_test/flutter_test.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());

    // group('showBottomSheet -', () {
    //   test('When called, should show custom bottom sheet using notice variant',
    //       () {
    //     final bottomSheetService = getAndRegisterBottomSheetService();
    //
    //     final model = getModel();
    //     model.showBottomSheet();
    //     verify(bottomSheetService.showCustomSheet(
    //       variant: BottomSheetType.notice,
    //       title: ksHomeBottomSheetTitle,
    //       description: ksHomeBottomSheetDescription,
    //     ));
    //   });
    // });
  });
}
