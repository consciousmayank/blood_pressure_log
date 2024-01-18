import 'package:app_blood_pressure_log/model_classes/record.dart';
import 'package:app_blood_pressure_log/ui/widgets/common/app_image_container/app_image_container.dart';
import 'package:flutter/material.dart';
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
    return Container(
      width: screenWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
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
                  Column(
                    children: [
                      const Text("Created On"),
                      AppRichTextView(
                        title: DateTimeToStringConverter.ddMMMMyyyy(
                                date: viewModel.recordToShow.logDate!)
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
          ButtonBar(
            children: [
              // ElevatedButton(
              //   onPressed: () => completer!(SheetResponse(
              //     confirmed: true,
              //   )),
              //   child: const Text(
              //     'Edit',
              //   ),
              // ),
              ElevatedButton(
                onPressed: () => completer!(SheetResponse(
                  confirmed: true,
                )),
                child: const Text(
                  'Done',
                ),
              ),
            ],
          )
        ],
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
