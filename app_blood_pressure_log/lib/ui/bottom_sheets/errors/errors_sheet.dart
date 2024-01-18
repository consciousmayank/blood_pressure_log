import 'package:app_blood_pressure_log/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'errors_sheet_model.dart';

class ErrorsSheet extends StackedView<ErrorsSheetModel> {
  final Function(SheetResponse response)? completer;
  final SheetRequest request;

  const ErrorsSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    ErrorsSheetModel viewModel,
    Widget? child,
  ) {
    ErrorsSheetInArgs args = request.data;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (args.title != null && args.title!.isNotEmpty)
            Text(
              args.title!,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
          verticalSpaceTiny,
          Text(
            args.description,
            style: const TextStyle(fontSize: 14, color: kcMediumGrey),
            maxLines: 3,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () => completer!(SheetResponse(
                  confirmed: true,
                )),
                child: const Text(
                  'Ok',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  ErrorsSheetModel viewModelBuilder(BuildContext context) => ErrorsSheetModel();
}

class ErrorsSheetInArgs {
  final String? title;
  final String description;

  ErrorsSheetInArgs({this.title, required this.description});
}
