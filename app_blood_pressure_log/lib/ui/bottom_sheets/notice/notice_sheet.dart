import 'package:app_blood_pressure_log/ui/common/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:app_blood_pressure_log/ui/common/app_colors.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'notice_sheet_model.dart';

class NoticeSheet extends StackedView<NoticeSheetModel> {
  final Function(SheetResponse)? completer;
  final SheetRequest request;
  const NoticeSheet({
    super.key,
    required this.completer,
    required this.request,
  });

  @override
  Widget builder(
    BuildContext context,
    NoticeSheetModel viewModel,
    Widget? child,
  ) {
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
          Text(
            request.title!,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
          ),
          verticalSpaceTiny,
          Text(
            request.description!,
            style: const TextStyle(fontSize: 14, color: kcMediumGrey),
            maxLines: 3,
            softWrap: true,
          ),
          if(request.mainButtonTitle!=null || request.secondaryButtonTitle!=null)
          ButtonBar(
            children: [
              if(request.mainButtonTitle!=null)
              OutlinedButton.icon(
                style: positiveOutlineButtonStyle(
                    foreGroundColor: Theme.of(context).primaryColor,
                    shadowColor: Theme.of(context).primaryColorDark),
                onPressed: () {
                  completer!(
                    SheetResponse(confirmed: true,),
                  );
                },
                icon: const Icon(Icons.check),
                label: Text(
                  request.mainButtonTitle!,
                ),
              ),
              verticalSpaceLarge,
              if(request.secondaryButtonTitle!=null)
              OutlinedButton.icon(
                style: negativeOutlineButtonStyle,
                onPressed: () {
                  completer!(
                    SheetResponse(confirmed: false,),
                  );
                },
                icon: const Icon(Icons.close),
                label: Text(
                  request.secondaryButtonTitle!,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  NoticeSheetModel viewModelBuilder(BuildContext context) => NoticeSheetModel();
}
