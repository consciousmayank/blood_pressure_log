import 'dart:async';

import 'package:app_blood_pressure_log/app/app.bottomsheets.dart';
import 'package:app_blood_pressure_log/app/app.dialogs.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:app_blood_pressure_log/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:testsweets/testsweets.dart';

Future<void> main() async {
  // if(!DRIVE_MODE) {
  WidgetsFlutterBinding.ensureInitialized();
  // }

  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await PushNotificationsService().initializePushNotifications();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  await setupTestSweets();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => TestSweetsOverlayView(
        enabled: false,
        projectId: 'aZdxh4Os4egKBdNptpip',
        captureWidgets: true,
        child: child!,
      ),
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
        TestSweetsNavigatorObserver(),
      ],
    );
  }
}
