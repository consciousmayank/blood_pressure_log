import 'package:app_blood_pressure_log/ui/common/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_styles.dart';
import 'app_intro_viewmodel.dart';

class AppIntroView extends StackedView<AppIntroViewModel> {
  const AppIntroView({super.key});

  @override
  Widget builder(
    BuildContext context,
    AppIntroViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: viewModel.pageController,
              pageSnapping: true,
              onPageChanged: (value) {
                viewModel.setIndex(value);
              },
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Things to keep in mind',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '1. Definition: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Blood pressure is the force exerted by blood against the walls of your arteries. It is measured in millimeters of mercury ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '(mmHg) ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'and has two values: systolic pressure ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '(when your heart beats) .',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: 'and diastolic pressure ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '(when your heart rests between beats).',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '2. Normal range: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Generally, a healthy blood pressure for adults is below ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '140/90 mmHg ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                '. Higher readings may indicate hypertension.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Recording tips',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '1. Rest before measuring: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Sit quietly for at least 5 minutes before taking your blood pressure. Avoid smoking, drinking caffeine, or exercising for at least 30 minutes beforehand.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '2. Position: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Sit with your back straight and supported, your feet flat on the floor, and your arm resting at heart level on a table.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '3. Cuff application: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Wrap the cuff snugly around your bare upper arm, about 1 inch above the elbow crease. Ensure the tubing runs down your arm.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '4. Measurement process: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Follow the instructions of your specific blood pressure monitor. Generally, it will inflate the cuff automatically, then gradually deflate while measuring your pulse. Remain still and breathe normally throughout the process.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '5. Multiple readings: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Take two or three readings at one-minute intervals and use the average.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Things to consider:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '1. Time of day: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Blood pressure is naturally highest in the morning and tends to be lower at night. Taking readings at consistent times (e.g., morning and evening) is recommended.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '2. Factors affecting readings: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Stress, anxiety, medications, and even posture can temporarily affect blood pressure. Record any influencing factors alongside your readings.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      verticalSpaceMedium,
                      const AppRichTextView.textSpans(
                        textAlign: TextAlign.start,
                        title: '3. Sharing with doctor: ',
                        textColor: Color(0xFF212121),
                        maxLines: 10,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        spans: [
                          TextSpan(
                            text:
                                'Regularly track your blood pressure readings and share them with your doctor during your appointments. This information helps monitor your health and adjust treatment plans if needed.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AnimatedSwitcher(
                  duration: 100.ms,
                  child: viewModel.currentIndex > 0
                      ? IconButton.filledTonal(
                          style: positiveOutlineButtonStyle(
                            foreGroundColor: Theme.of(context).primaryColorDark,
                            shadowColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: viewModel.currentIndex > 0
                              ? () {
                                  viewModel.pageController.previousPage(
                                      duration: 1.seconds,
                                      curve: Curves.decelerate);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_left))
                      : const SizedBox.shrink(),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [1, 2, 3]
                        .map(
                          (e) => Container(
                            height: 1,
                            width: 1,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  viewModel.currentIndex == [1, 2, 3].indexOf(e)
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                          )
                              .appCard(
                                  shadowColor: Theme.of(context).primaryColor,
                                  cardColor: viewModel.currentIndex ==
                                          [1, 2, 3].indexOf(e)
                                      ? Theme.of(context).primaryColorDark
                                      : Theme.of(context).primaryColor)
                              .animate()
                              .scale(),
                        )
                        .toList(),
                  )),
              Expanded(
                flex: 1,
                child: AnimatedSwitcher(
                  duration: 100.ms,
                  child: viewModel.currentIndex < 2
                      ? IconButton.filledTonal(
                          style: positiveOutlineButtonStyle(
                            foreGroundColor: Theme.of(context).primaryColorDark,
                            shadowColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: viewModel.currentIndex < 2
                              ? () {
                                  viewModel.pageController.nextPage(
                                      duration: 1.seconds,
                                      curve: Curves.decelerate);
                                }
                              : null,
                          icon: const Icon(Icons.arrow_right))
                      : TextButton(
                          style: positiveTextButtonStyle(
                            backgroundColor: Theme.of(context).cardColor,
                            foreGroundColor: Theme.of(context).primaryColor,
                            shadowColor: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            viewModel.takeToPermissionsScreen();
                          },
                          child: const Text(
                            "Next",
                          ),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  AppIntroViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppIntroViewModel();
}
