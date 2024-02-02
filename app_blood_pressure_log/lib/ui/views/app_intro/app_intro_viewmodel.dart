import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppIntroViewModel extends IndexTrackingViewModel {
  late final PageController pageController;
  final InterFaceAppPreferences _preferencesService = locator<AppPreferencesService>();
  final NavigationService _navigationService = locator<NavigationService>();

  AppIntroViewModel(){
    pageController = PageController(initialPage: 0, viewportFraction: 0.9);
  }

  void takeToPermissionsScreen() {
    _preferencesService.shownAppIntroOnce(true);
    _navigationService.back();
  }
}
