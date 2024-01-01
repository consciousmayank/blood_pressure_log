import 'package:app_blood_pressure_log/app/app.dialogs.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:helper_package/helper_package.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'blood_monitor_help_model.dart';

class BloodMonitorHelp extends StackedView<BloodMonitorHelpModel> {
  final Function? onFirstEntryMade;
  final bool isDialog;
  const BloodMonitorHelp({
    super.key,
    this.isDialog = false,
    required this.onFirstEntryMade,
  });

  @override
  Widget builder(
    BuildContext context,
    BloodMonitorHelpModel viewModel,
    Widget? child,
  ) {
    return isDialog
        ? mainView(context)
        : Center(
            child: SizedBox.fromSize(
              size: Size(
                screenWidth(context) * 0.75,
                screenHeight(context) * 0.55,
              ),
              child: mainView(
                context,
              ),
            ),
          );
  }

  Widget showCard({required Widget child}) {
    return isDialog
        ? child
        : Card(
            child: child,
          );
  }

  Widget mainView(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: showCard(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
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
                        text: '. Higher readings may indicate hypertension.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
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
                  verticalSpaceMedium,
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
                  verticalSpaceSmall,
                ],
              ),
            ),
          ),
        ),
        if (!isDialog)
          ElevatedButton.icon(
              onPressed: () async {
                DialogResponse? response =
                    await locator<DialogService>().showCustomDialog(
                  variant: DialogType.addEntry,
                );

                if (response != null && response.confirmed) {
                  onFirstEntryMade?.call();
                }
              },
              icon: const Icon(Icons.send),
              label: const Text('Add first reading'))
      ],
    );
  }

  @override
  BloodMonitorHelpModel viewModelBuilder(
    BuildContext context,
  ) =>
      BloodMonitorHelpModel();
}
