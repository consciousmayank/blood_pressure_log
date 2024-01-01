import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:stacked/stacked.dart';

class AppImageContainerModel extends BaseViewModel {
  final InterFaceAppPreferences _preferencesService =
      locator<AppPreferencesService>();
  fetchToken() {
    return _preferencesService.fetchImageToken();
  }
}
