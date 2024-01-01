import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'B.P.L.',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline),
            ),
            verticalSpaceSmall,
            Text(
              'Blood Pressure Log',
              style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColorDark),
            ),
            verticalSpaceLarge,
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome ...', style: TextStyle(fontSize: 16)),
                horizontalSpaceSmall,
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 6,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) =>
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        viewModel.runStartupLogic();
      });
}
