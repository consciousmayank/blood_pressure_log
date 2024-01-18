import 'package:app_blood_pressure_log/app/app.logger.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app_widget_viewmodel.dart';

class AppWidgetView extends StatefulWidget {
  const AppWidgetView({
    super.key,
  });

  @override
  State<AppWidgetView> createState() => _AppWidgetViewState();
}

class _AppWidgetViewState extends State<AppWidgetView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: ViewModelBuilder<AppWidgetViewModel>.reactive(
        viewModelBuilder: () => AppWidgetViewModel(),
        builder: (context, model, child) => MaterialApp(
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
          ],
        ),
      ),
    );
  }
}
