import 'package:app_blood_pressure_log/app/app.bottomsheets.dart';
import 'package:app_blood_pressure_log/app/app.dialogs.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/app/app.snackbar.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/view_record/view_record_sheet.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/view_record/view_record_sheet_model.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();
  Map<String, List<Records>> recordsList = {};

  void fetchAllRecords() async {
    recordsList = await runBusyFuture(
      _networkService.getRecords(),
      busyObject: fetchRecordsBusyObject,
    );
    rebuildUi();
  }

  void logout() async {
    await _networkService.logout();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  getAvg({required String date}) {
    List<Records> recordForDate = recordsList[date] ?? [];
    int systolicValueSum = recordForDate
        .map((e) => e.systolicValue)
        .toList()
        .reduce((value, element) => value + element);
    int diastolicValueSum = recordForDate
        .map((e) => e.diastolicValue)
        .toList()
        .reduce((value, element) => value + element);

    return '${(systolicValueSum / recordForDate.length).toStringAsFixed(2)}/${(diastolicValueSum / recordForDate.length).toStringAsFixed(2)}';
  }

  void showHelp() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      barrierDismissible: true,
    );
  }

  void openRecordViewBottomSheet({required Records recordToView}) async {
    SheetResponse? response = await _bottomSheetService.showCustomSheet(
        barrierDismissible: true,
        variant: BottomSheetType.viewRecord,
        data: ViewRecordSheetModelInArguments(
          recordToShow: recordToView,
        ),
        isScrollControlled: true);

    if (response != null && response.confirmed) {
      if (response.data is ViewRecordOption) {
        ViewRecordOption option = response.data;
        if (option == ViewRecordOption.deleted_record) {
          _snackBarService.showCustomSnackBar(
            message: 'Record Deleted',
            variant: SnackBarType.normal,
          );
          fetchAllRecords();
        } else if (option == ViewRecordOption.edit_record) {
          openAddNewRecordView(recordToEdit: recordToView);
        }
      } else {}
    }
  }

  void openAddNewRecordView({
    Records? recordToEdit,
  }) async {
    SheetResponse? response = await _bottomSheetService.showCustomSheet(
        barrierDismissible: true,
        variant: BottomSheetType.addRecord,
        data: recordToEdit,
        isScrollControlled: true);

    if (response != null && response.confirmed) {
      fetchAllRecords();

      if (response.data != null && recordToEdit != null) {
        Records updatedRecord = response.data as Records;

        openRecordViewBottomSheet(recordToView: updatedRecord);
      }
    }
  }
}
