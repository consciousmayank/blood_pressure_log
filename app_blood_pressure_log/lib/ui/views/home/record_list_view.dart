import 'package:app_blood_pressure_log/ui/views/home/home_viewmodel.dart';
import 'package:app_blood_pressure_log/ui/widgets/common/app_image_container/app_image_container.dart';
import 'package:flutter/material.dart';
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
              variant: SnackbarType.normal,
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
              ActionChip(
                  shape: getCardShape(radius: 20),
                  padding: const EdgeInsets.all(2),
                  label: Text('Avg. ${viewModel.getAvg(
                    date: viewModel.recordsList.keys.elementAt(
                      index,
                    ),
                  )}'))
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Wrap(
              clipBehavior: Clip.antiAlias,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.end,
              direction: Axis.horizontal,
              spacing: 2,
              alignment: WrapAlignment.end,
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
