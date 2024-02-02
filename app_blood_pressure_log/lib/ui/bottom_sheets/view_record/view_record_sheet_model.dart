import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';

class ViewRecordSheetModel extends BaseViewModel {
  final IAppNetworkService _networkService = locator<AppNetworkService>();

  late ViewRecordOption option;
  final Records recordToShow;

  ViewRecordSheetModel({required this.recordToShow}) {
    option = ViewRecordOption.view_record;
  }

  Future onConfirmButtonClicked() async {
    switch (option) {
      case ViewRecordOption.view_record:
      case ViewRecordOption.deleted_record:
        break;
      case ViewRecordOption.delete_record:
        if (recordToShow.id != null) {
          bool deleteResult = await runBusyFuture(
            _networkService.deleteRecord(recordId: recordToShow.id!),
            busyObject: deleteRecordBusyObject,
          );
          if (deleteResult) {
            option = ViewRecordOption.deleted_record;
            rebuildUi();
          }
        }

        break;
      case ViewRecordOption.edit_record:
        break;
    }
  }

  Future<bool> deleteRecord() async {
    if (recordToShow.id != null) {
      return await runBusyFuture(
        _networkService.deleteRecord(recordId: recordToShow.id!),
        busyObject: deleteRecordBusyObject,
      );
      // if (deleteResult) {
      //   option = ViewRecordOption.deleted_record;
      //   rebuildUi();
      // }
    } else {
      return false;
    }
  }
}

enum ViewRecordOption {
  view_record,
  delete_record,
  edit_record,
  deleted_record,
}
