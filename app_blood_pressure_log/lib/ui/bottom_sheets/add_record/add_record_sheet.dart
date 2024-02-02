import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.snackbar.dart';
import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/ui/bottom_sheets/add_record/add_record_sheet.form.dart';
import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/common/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'add_record_sheet_model.dart';

@FormView(fields: [
  FormTextField(name: 'systolicValueInput'),
  FormTextField(name: 'diastolicValueInput'),
])
class AddRecordSheet extends StackedView<AddRecordSheetModel>
    with $AddRecordSheet {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const AddRecordSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddRecordSheetModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: !viewModel.anyObjectsBusy,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: viewModel.busy(createRecordBusyObject)
            ? SizedBox(
                height: screenHeight(context) / 4,
                child: const LoadingWidget(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    child: AppIconWidget.nonBorderedBase64(
                      size: Size(
                        screenWidth(context),
                        screenWidth(context),
                      ),
                      iconsBase64String: viewModel.imageBase64String,
                      imageFit: BoxFit.fitWidth,
                    ),
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: systolicValueInputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText:
                                viewModel.systolicValueInputValidationMessage,
                            labelText: 'Systolic Value',
                            hintText: 'Eg: 120',
                            hintStyle: const TextStyle(color: Colors.grey),
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onEditingComplete: () =>
                              diastolicValueInputFocusNode.requestFocus(),
                          onFieldSubmitted: (value) =>
                              diastolicValueInputFocusNode.requestFocus(),
                        ),
                      ),
                      horizontalSpaceMedium,
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          focusNode: diastolicValueInputFocusNode,
                          controller: diastolicValueInputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Diastolic Value',
                            errorText:
                                viewModel.diastolicValueInputValidationMessage,
                            hintText: 'Eg: 80',
                            hintStyle: const TextStyle(color: Colors.grey),
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onFieldSubmitted: (value) =>
                              hideKeyboard(context: context),
                          onEditingComplete: () =>
                              hideKeyboard(context: context),
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton.filledTonal(
                          style: negativeOutlineButtonStyle,
                          tooltip: "Cancel",
                          focusColor: Colors.blue,
                          onPressed: () {
                            completer!(
                              SheetResponse(
                                confirmed: false,
                              ),
                            );
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.red),
                      const Spacer(),
                      if ((request.data) == null)
                        IconButton.filledTonal(
                          style: positiveOutlineButtonStyle(
                            foreGroundColor: Theme.of(context).primaryColorDark,
                            shadowColor: Theme.of(context).primaryColor,
                          ),
                          tooltip: "Capture Image",
                          onPressed: () async {
                            viewModel.captureImageFromCamera();
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      if ((request.data) == null)
                        IconButton.filledTonal(
                          style: positiveOutlineButtonStyle(
                            foreGroundColor: Theme.of(context).primaryColorDark,
                            shadowColor: Theme.of(context).primaryColor,
                          ),
                          tooltip: "Upload Image",
                          onPressed: () async {
                            viewModel.pickImageFromGallery();
                          },
                          icon: Icon(
                            Icons.photo_album,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      const Spacer(),
                      IconButton.filledTonal(
                        style: positiveOutlineButtonStyle(
                          foreGroundColor: Theme.of(context).primaryColor,
                          shadowColor: Theme.of(context).primaryColorDark,
                        ),
                        tooltip: "Save Record",
                        onPressed: () async {
                          if (viewModel.recordToUpdate == null) {
                            var createRecord = (await viewModel.saveData());
                            if (createRecord != null) {
                              if (createRecord.isSuccess != null &&
                                  createRecord.isSuccess!) {
                                locator<SnackbarService>().showCustomSnackBar(
                                  message: 'Record Added',
                                  variant: SnackBarType.normal,
                                );
                                completer!(
                                  SheetResponse(
                                      confirmed: true,
                                      data: createRecord.record),
                                );
                              }
                            }
                          } else {
                            var updatedRecord = (await viewModel.updateData());
                            if (updatedRecord != null) {
                              if (updatedRecord.isSuccess != null &&
                                  updatedRecord.isSuccess!) {
                                locator<SnackbarService>().showCustomSnackBar(
                                  message: 'Record updated',
                                  variant: SnackBarType.normal,
                                );
                                completer!(
                                  SheetResponse(
                                      confirmed: true,
                                      data: updatedRecord.record),
                                );
                              }
                            }
                          }
                        },
                        icon: Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ].animate(delay: 400.ms).flipH(),
                  )
                ].animate().fadeIn(duration: 500.ms),
              ),
      ),
    );
  }

  @override
  void onViewModelReady(AddRecordSheetModel viewModel) {
    syncFormWithViewModel(viewModel);
    if ((request.data) != null) {
      Records recordToUpdate = (request.data);
      systolicValueInputController.text =
          recordToUpdate.systolicValue.toString();
      diastolicValueInputController.text =
          recordToUpdate.diastolicValue.toString();
    }
  }

  @override
  void onDispose(AddRecordSheetModel viewModel) {
    viewModel.clearForm();
    super.onDispose(viewModel);
  }

  @override
  AddRecordSheetModel viewModelBuilder(BuildContext context) =>
      AddRecordSheetModel(
          recordToUpdate:
              request.data == null ? null : request.data as Records);
}
