import 'package:app_blood_pressure_log/ui/common/app_strings.dart';
import 'package:app_blood_pressure_log/ui/views/home/record_list_view.dart';
import 'package:app_blood_pressure_log/ui/widgets/common/blood_monitor_help/blood_monitor_help.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Pressure Monitor'),
        actions: [
          ThemePopUpMenuWidget(
            options: <PopUpMenuOptions>[
              PopUpMenuOptions(
                menuValue: 1,
                onMenuItemSelected: () {
                  viewModel.openAddNewRecordView();
                },
                menuIcon: const Icon(
                  Icons.add,
                ),
                menuTitle: 'New Entry',
              ),
              PopUpMenuOptions(
                menuValue: 2,
                onMenuItemSelected: () {
                  viewModel.logout();
                },
                menuIcon: const Icon(
                  Icons.logout,
                ),
                menuTitle: 'Logout',
              ),
              if (viewModel.recordsList.isNotEmpty)
                PopUpMenuOptions(
                  menuValue: 3,
                  onMenuItemSelected: () {
                    viewModel.showHelp();
                  },
                  menuIcon: const Icon(
                    Icons.help,
                  ),
                  menuTitle: 'Help',
                )
            ],
            toolTip: 'Select an option',
            icon: Icon(
              Icons.more_vert_rounded,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: viewModel.busy(fetchRecordsBusyObject)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : viewModel.recordsList.isEmpty
                  ? BloodMonitorHelp(
                      onFirstEntryMade: () {
                        viewModel.fetchAllRecords();
                      },
                    )
                  : const RecordListView(),
        ),
      ),
    );
  }

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    viewModel.fetchAllRecords();
    super.onViewModelReady(viewModel);
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
