import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/ui/common/app_styles.dart';
import 'package:app_blood_pressure_log/ui/widgets/common/app_image_container/app_image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'view_record_sheet_model.dart';

class ViewRecordSheet extends StackedView<ViewRecordSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const ViewRecordSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    ViewRecordSheetModel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: !viewModel.anyObjectsBusy,
      child: Container(
        width: screenWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: viewModel.anyObjectsBusy
            ? SizedBox(
                height: screenHeight(context) / 4,
                child: const LoadingWidget(),
              )
            : viewModel.option == ViewRecordOption.deleted_record
                ? ConfirmationView.confirmButton(
                    title: 'Record Deleted',
                    onConfirmButtonClicked: () {
                      completer!(
                        SheetResponse(confirmed: true, data: viewModel.option),
                      );
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          (viewModel.recordToShow.imageUrl.isNotEmpty)
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Card(
                                    elevation: 5,
                                    clipBehavior: Clip.antiAlias,
                                    child: AppImageContainer(
                                      imageUrl: viewModel.recordToShow.imageUrl,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Column(
                            children: [
                              Column(
                                children: [
                                  const Text("Diastolic Value"),
                                  AppRichTextView(
                                    title: viewModel.recordToShow.diastolicValue
                                        .toStringAsFixed(
                                      2,
                                    ),
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    textColor: Colors.black,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Systolic Value"),
                                  AppRichTextView(
                                    title: viewModel.recordToShow.systolicValue
                                        .toStringAsFixed(
                                      2,
                                    ),
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal,
                                    textColor: Colors.black,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const Divider(),
                              if (viewModel.recordToShow.logDate != null)
                                Column(
                                  children: [
                                    const Text("Created On"),
                                    AppRichTextView(
                                      title:
                                          DateTimeToStringConverter.ddMMMMyyyy(
                                                  date: viewModel
                                                      .recordToShow.logDate!)
                                              .convert(),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      textColor: Colors.black,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      (viewModel.option == ViewRecordOption.delete_record ||
                              viewModel.option == ViewRecordOption.edit_record)
                          ? ConfirmationView(
                              onCancelButtonClicked: () {
                                viewModel.option = ViewRecordOption.view_record;
                                viewModel.rebuildUi();
                              },
                              onConfirmButtonClicked: () async {
                                if (viewModel.option ==
                                    ViewRecordOption.edit_record) {
                                  completer!(
                                    SheetResponse(
                                        confirmed: true,
                                        data: viewModel.option),
                                  );
                                } else if (viewModel.option ==
                                    ViewRecordOption.delete_record) {
                                  bool recordDeleted =
                                      await viewModel.deleteRecord();
                                  if (recordDeleted) {
                                    completer!(
                                      SheetResponse(
                                        confirmed: true,
                                        data: ViewRecordOption.deleted_record,
                                      ),
                                    );
                                  }
                                }
                              },
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton.filledTonal(
                                  style: positiveOutlineButtonStyle(
                                    foreGroundColor: Theme.of(context).primaryColor,
                                    shadowColor: Theme.of(context).primaryColorDark,
                                  ),
                                  tooltip: "Edit Record",
                                  onPressed: () async {
                                    viewModel.option =
                                        ViewRecordOption.edit_record;
                                    viewModel.rebuildUi();
                                  },
                                  icon: Icon(
                                    Icons.edit_note,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                                const Spacer(),
                                IconButton.filledTonal(
                                  style: negativeOutlineButtonStyle,
                                  tooltip: "Delete Record",
                                  onPressed: () async {
                                    viewModel.option =
                                        ViewRecordOption.delete_record;
                                    viewModel.rebuildUi();
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ].animate(delay: 400.ms).flipH(),
                            ),
                    ].animate().fadeIn(duration: 800.ms),
                  ),
      ),
    );
  }

  @override
  ViewRecordSheetModel viewModelBuilder(BuildContext context) =>
      ViewRecordSheetModel(
          recordToShow:
              (request.data as ViewRecordSheetModelInArguments).recordToShow);
}

class ViewRecordSheetModelInArguments {
  final Records recordToShow;

  ViewRecordSheetModelInArguments({required this.recordToShow});
}

class ConfirmationView extends ViewModelWidget<ViewRecordSheetModel> {
  const ConfirmationView({
    super.key,
    required this.onCancelButtonClicked,
    required this.onConfirmButtonClicked,
    this.title,
  });

  const ConfirmationView.noButtons({
    super.key,
    this.onCancelButtonClicked,
    this.onConfirmButtonClicked,
    required this.title,
  });

  const ConfirmationView.confirmButton({
    super.key,
    this.onCancelButtonClicked,
    required this.onConfirmButtonClicked,
    required this.title,
  });

  final VoidCallback? onCancelButtonClicked;
  final VoidCallback? onConfirmButtonClicked;
  final String? title;

  @override
  Widget build(BuildContext context, ViewRecordSheetModel viewModel) {
    return Row(
      children: [
        if (onCancelButtonClicked != null)
          IconButton.filledTonal(
            style: negativeOutlineButtonStyle,
            tooltip: "Cancel",
            focusColor: Colors.blue,
            onPressed: () {
              onCancelButtonClicked?.call();
            },
            icon: const Icon(Icons.close),
            color: Colors.red,
          ).animate(delay: 400.ms).flipH(),
        Expanded(
          flex: 1,
          child: Text(
            onCancelButtonClicked == null || onConfirmButtonClicked == null
                ? title ?? ''
                : viewModel.option == ViewRecordOption.delete_record
                    ? "Are you sure you want to delete this record?"
                    : "Are you sure you want to edit this record?",
            maxLines: 3,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                duration: 4200.ms,
                color: Theme.of(context).primaryColorDark,
              ),
        ),
        if (onConfirmButtonClicked != null)
          IconButton.filledTonal(
            style: positiveOutlineButtonStyle(
              foreGroundColor: Theme.of(context).primaryColor,
              shadowColor: Theme.of(context).primaryColorDark,
            ),
            tooltip: "Done",
            onPressed: () async {
              onConfirmButtonClicked?.call();
            },
            icon: Icon(
              Icons.check,
              color: Theme.of(context).primaryColor,
            ),
          ).animate(delay: 400.ms).flipH(),
      ].animate().fadeIn(duration: 800.ms),
    );
  }
}
