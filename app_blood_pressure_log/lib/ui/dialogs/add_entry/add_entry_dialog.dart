import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/dialogs/add_entry/add_entry_dialog.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:helper_package/helper_package.dart';

import 'add_entry_dialog_model.dart';

@FormView(fields: [
  FormTextField(name: 'systolicValueInput'),
  FormTextField(name: 'diastolicValueInput'),
])
class AddEntryDialog extends StackedView<AddEntryDialogModel>
    with $AddEntryDialog {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AddEntryDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddEntryDialogModel viewModel,
    Widget? child,
  ) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: viewModel.busy(createRecordBusyObject)
            ? SizedBox(
              height: screenHeight(context)/4,
              width: screenHeight(context)/4,
              child: const Center(
                  child: CircularProgressIndicator(),
                ),
            )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Blood pressure entry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: systolicValueInputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText:
                                viewModel.systolicValueInputValidationMessage,
                            labelText: 'Enter Systolic Value',
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
                      horizontalSpaceTiny,
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          focusNode: diastolicValueInputFocusNode,
                          controller: diastolicValueInputController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Diastolic Value',
                            errorText:
                                viewModel.diastolicValueInputValidationMessage,
                            hintText: 'Eg: 80',
                            hintStyle: TextStyle(color: Colors.grey),
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
                  AppIconWidget.nonBorderedBase64(
                    size: Size(
                      screenWidth(context),
                      screenWidth(context) / 2,
                    ),
                    iconsBase64String: viewModel.imageBase64String,
                    imageFit: BoxFit.fitHeight,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ThemePopUpMenuWidget(
                        icon: Icon(
                          Icons.upload,
                          color: Theme.of(context).primaryColor,
                        ),
                        options: <PopUpMenuOptions>[
                          PopUpMenuOptions(
                            menuValue: 1,
                            onMenuItemSelected: () {
                              viewModel.captureImageFromCamera();
                            },
                            menuIcon: const Icon(
                              Icons.add_a_photo,
                            ),
                            menuTitle: 'Capture from Camera',
                          ),
                          PopUpMenuOptions(
                            menuValue: 2,
                            onMenuItemSelected: () {
                              viewModel.pickImageFromGallery();
                            },
                            menuIcon: const Icon(
                              Icons.image_rounded,
                            ),
                            menuTitle: 'Salect from gallery',
                          )
                        ],
                        toolTip: 'Upload Image',
                      ),
                      horizontalSpaceMedium,
                      AppButton.centerIcon(
                        onPressed: () async {
                          var createRecord = (await viewModel.saveData());
                          if (createRecord != null) {
                            if (createRecord.isSuccess != null &&
                                createRecord.isSuccess!) {
                              completer(
                                DialogResponse(
                                    confirmed: true, data: createRecord.record),
                              );
                            }
                          }
                        },
                        icon: Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        btnBg: Theme.of(context).primaryColor,
                        buttonTextColor: Colors.black,
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  @override
  void onViewModelReady(AddEntryDialogModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(AddEntryDialogModel viewModel) {
    viewModel.clearForm();
    super.onDispose(viewModel);
  }

  @override
  AddEntryDialogModel viewModelBuilder(BuildContext context) =>
      AddEntryDialogModel();
}
