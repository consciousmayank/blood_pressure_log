import 'package:app_blood_pressure_log/app/app.snackbar.dart';
import 'package:app_blood_pressure_log/ui/views/home/home_viewmodel.dart';
import 'package:app_blood_pressure_log/ui/widgets/common/app_image_container/app_image_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class RecordListView extends ViewModelWidget<HomeViewModel> {
  const RecordListView({super.key});

  @override
  Widget build(
    BuildContext context,
    HomeViewModel viewModel,
  ) {
    return ListView.builder(
      itemBuilder: (context, index) => Card(
        shape: getCardShape(),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: () {
            locator<SnackbarService>().showCustomSnackBar(
              message: 'Open Bottom sheet to view all entries of this day',
              variant: SnackBarType.normal,
            );
          },
          title: Row(
            children: [
              Text(
                viewModel.recordsList.keys
                    .elementAt(
                      index,
                    )
                    .replaceAll('-', ' '),
              ),
              const Spacer(),
              Text(
                '${viewModel.recordsList.values.elementAt(index).length} ${viewModel.recordsList.values.elementAt(index).length > 1 ? 'records' : 'record'}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                    duration: 4200.ms,
                    color: Theme.of(context).primaryColorDark,
                  ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Wrap(
              clipBehavior: Clip.antiAlias,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              direction: Axis.horizontal,
              spacing: 3,
              alignment: WrapAlignment.center,
              children: viewModel.recordsList.values
                  .elementAt(index)
                  .map(
                    (e) => ActionChip(
                      avatar: e.imageUrl.isEmpty
                          ? null
                          : ClipRRect(
                              borderRadius: getBorderRadius(radius: 20),
                              clipBehavior: Clip.antiAlias,
                              child: AppImageContainer(
                                imageUrl: e.imageUrl,
                                height: 25,
                                width: 25,
                              ),
                            ),
                      shape: getCardShape(radius: 20),
                      padding: const EdgeInsets.all(2),
                      onPressed: () {
                        viewModel.openRecordViewBottomSheet(recordToView: e);
                      },
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      label: Text(
                        '${e.diastolicValue}/${e.systolicValue}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      itemCount: viewModel.recordsList.length,
    );
  }
}
