import 'package:flutter/material.dart';
import 'package:app_blood_pressure_log/app/app.bottomsheets.dart';
import 'package:app_blood_pressure_log/app/app.dialogs.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}
