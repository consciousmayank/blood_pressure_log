import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    Widget title = Text(
      'Blood Pressure Log',
      style: TextStyle(
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).primaryColorDark),
    );

    // title = title
    //     .animate(onPlay: (controller) => controller.repeat(reverse: true))
    //     .fadeOut();
    Widget b = const Text(
      'B',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 64,
        color: Color(0xFF666870),
        height: 0.9,
        letterSpacing: -5,
      ),
    );

    Widget p = const Text(
      'P',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 64,
        color: Color(0xFF666870),
        height: 0.9,
        letterSpacing: -5,
      ),
    );

    Widget l = const Text(
      'L',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 64,
        color: Color(0xFF666870),
        height: 0.9,
        letterSpacing: -5,
      ),
    );

    Widget dot = const Text(
      '.',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 64,
        color: Color(0xFF666870),
        height: 0.9,
        letterSpacing: -5,
      ),
    );

    Widget loadingDot = const Text(
      '.',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16,
        color: Color(0xFF666870),
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                b
                    .animate()
                    .moveX(begin: -200, end: 0, duration: 800.milliseconds),
                dot.animate().fadeIn(
                    begin: 0,
                    duration: 800.milliseconds,
                    delay: 800.milliseconds),
                p
                    .animate()
                    .moveY(begin: -200, end: 0, duration: 800.milliseconds),
                dot.animate().fadeIn(
                    begin: 0,
                    duration: 800.milliseconds,
                    delay: 800.milliseconds),
                l
                    .animate()
                    .moveX(begin: 400, end: 0, duration: 800.milliseconds),
              ],
            ),
            verticalSpaceSmall,
            title.animate().moveY(
                begin: screenHeight(context),
                end: 0,
                duration: 900.milliseconds),
            verticalSpaceLarge,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Loading ',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFF666870),
                    )),
                loadingDot
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .fadeIn(duration: 200.milliseconds, delay: 300.milliseconds)
                    .then()
                    .fadeOut(duration: 300.milliseconds),
                loadingDot
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .fadeIn(duration: 200.milliseconds, delay: 300.milliseconds)
                    .then()
                    .fadeOut(duration: 300.milliseconds),
                loadingDot
                    .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true))
                    .fadeIn(duration: 200.milliseconds, delay: 300.milliseconds)
                    .then()
                    .fadeOut(duration: 300.milliseconds),
                horizontalSpaceSmall,
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
