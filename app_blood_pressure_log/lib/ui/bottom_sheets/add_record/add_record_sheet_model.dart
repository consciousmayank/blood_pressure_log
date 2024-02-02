import 'dart:convert';
import 'dart:io';

import 'package:app_blood_pressure_log/app/app.bottomsheets.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/services/app_permissions_service.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/add_record/add_record_sheet.form.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:helper_package/helper_package.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddRecordSheetModel extends FormViewModel {
  final Records? recordToUpdate;
  String imageUrl = '';
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  String? imageBase64String;
  AppImagePickerService? imageFilePickService;
  final AppPermissionsService _appPermissionsService =
      locator<AppPermissionsService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  AddRecordSheetModel({required this.recordToUpdate});

  void captureImageFromCamera() async {
    if (_appPermissionsService.getPermissionFor(
            permission: Permission.camera) ==
        PermissionStatus.granted) {
      imageFilePickService = AppImagePickerService(
          selectedOption: ImagePickerOptions.takePhotoFromCamera);
      int size = await imageFilePickService!.pick();
      if (imageFilePickService!.isFilePicked()) {
        imageBase64String = base64Encode(
          imageFilePickService!
                  .getFile()
                  .userSelectedFileDetails
                  .imageBytes
                  ?.toList() ??
              [],
        );
        rebuildUi();
      }
    } else if (_appPermissionsService.getPermissionFor(
            permission: Permission.camera) ==
        PermissionStatus.permanentlyDenied) {
      SheetResponse? noticeSheetResponse =
          await _bottomSheetService.showCustomSheet(
              variant: BottomSheetType.notice,
              title: "Camera Permission denied permanently",
              description: "Open settings to allow permissions",
            mainButtonTitle: "Yes",
            secondaryButtonTitle: "No"
          );

      if (noticeSheetResponse != null && noticeSheetResponse.confirmed) {
        openAppSettings();
      }
    } else {
      _appPermissionsService
          .requestAppPermissions()
          .then((value) => captureImageFromCamera());
    }
  }

  void pickImageFromGallery() async {
    imageFilePickService = AppImagePickerService(
        selectedOption: ImagePickerOptions.chooseFromGallery);
    int size = await imageFilePickService!.pick();
    if (imageFilePickService!.isFilePicked()) {
      imageBase64String = base64.encode(
        imageFilePickService!
                .getFile()
                .userSelectedFileDetails
                .imageBytes
                ?.toList() ??
            [],
      );
      rebuildUi();
    }
  }

  bool isFormInValid() {
    bool isFormInValid = false;
    if (systolicValueInputValue?.isEmpty == true) {
      setSystolicValueInputValidationMessage('Required');
      isFormInValid = true;
    }
    if (diastolicValueInputValue?.isEmpty == true) {
      setDiastolicValueInputValidationMessage('Required');
      isFormInValid = true;
    }
    return isFormInValid;
  }

  Future<({bool? isSuccess, Records? record})?> saveData() async {
    if (isFormInValid()) {
      rebuildUi();
      return (isSuccess: false, record: null);
    } else {
      Records newRecord = Records(
        systolicValue: int.tryParse(systolicValueInputValue!) ?? 0,
        diastolicValue: int.tryParse(diastolicValueInputValue!) ?? 0,
        imageUrl: "",
      );

      bool isSuccess = await runBusyFuture(
        _networkService.createRecord(
          record: newRecord,
          imageFile: imageFilePickService
                      ?.getFile()
                      .userSelectedFileDetails
                      .pickedFile
                      ?.path !=
                  null
              ? File(imageFilePickService!
                  .getFile()
                  .userSelectedFileDetails
                  .pickedFile!
                  .path)
              : null,
        ),
        busyObject: createRecordBusyObject,
      );

      return (isSuccess: isSuccess, record: newRecord);
    }
  }

  Future<({bool? isSuccess, Records? record})?> updateData() async {
    if (isFormInValid()) {
      rebuildUi();
      return (isSuccess: false, record: null);
    } else {
      Records updatedRecord = Records(
        systolicValue: int.tryParse(systolicValueInputValue!) ??
            recordToUpdate?.systolicValue ??
            00,
        diastolicValue: int.tryParse(diastolicValueInputValue!) ??
            recordToUpdate?.diastolicValue ??
            0,
        imageUrl: recordToUpdate?.imageUrl ?? '',
        id: recordToUpdate?.id,
        logDate: recordToUpdate?.logDate,
      );

      bool isSuccess = await runBusyFuture(
        _networkService.updateRecord(
          record: updatedRecord,
        ),
        busyObject: createRecordBusyObject,
      );

      return (isSuccess: isSuccess, record: updatedRecord);
    }
  }
}
