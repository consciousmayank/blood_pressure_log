import 'dart:convert';
import 'dart:io';

import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/dialogs/add_entry/add_entry_dialog.form.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddEntryDialogModel extends FormViewModel {
  String imageUrl = '';
  final IAppNetworkService _networkService = locator<AppNetworkService>();
  String? imageBase64String;
  AppImagePickerService? imageFilePickService;

  void captureImageFromCamera() async {
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

  Future<({bool? isSuccess, Records? record})?> saveData() async {
    if (systolicValueInputValue?.isEmpty == true) {
      setSystolicValueInputValidationMessage('Required');
      rebuildUi();
      return null;
    }
    if (diastolicValueInputValue?.isEmpty == true) {
      setDiastolicValueInputValidationMessage('Required');
      rebuildUi();
      return null;
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
}
