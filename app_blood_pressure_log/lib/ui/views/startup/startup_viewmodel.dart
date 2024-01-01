import 'package:app_blood_pressure_log/services/app_network_service.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final InterFaceAppPreferences _preferencesService =
      locator<AppPreferencesService>();
  final IAppNetworkService _networkService = locator<AppNetworkService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Permission.camera.onDeniedCallback(() {
      // Your code
    }).onGrantedCallback(() {
      // Your code
    }).onPermanentlyDeniedCallback(() {
      // Your code
    }).onRestrictedCallback(() {
      // Your code
    }).onLimitedCallback(() {
      // Your code
    }).onProvisionalCallback(() {
      // Your code
    }).request();

    await Permission.photos.onDeniedCallback(() {
      // Your code
    }).onGrantedCallback(() {
      // Your code
    }).onPermanentlyDeniedCallback(() {
      // Your code
    }).onRestrictedCallback(() {
      // Your code
    }).onLimitedCallback(() {
      // Your code
    }).onProvisionalCallback(() {
      // Your code
    }).request();

    await _networkService.fetchAppConfigs();

    if (_preferencesService.isUserLoggedIn()) {
      _navigationService.replaceWithHomeView();
    } else {
      _navigationService.replaceWithLoginView();
    }
  }
}
