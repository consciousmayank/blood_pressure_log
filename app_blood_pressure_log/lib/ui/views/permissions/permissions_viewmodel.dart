import 'package:app_blood_pressure_log/app/app.locator.dart';
import 'package:app_blood_pressure_log/services/app_permissions_service.dart';
import 'package:app_blood_pressure_log/services/app_preferences_service.dart';
import 'package:app_blood_pressure_log/services/push_notifications_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PermissionsViewModel extends BaseViewModel {
  final AppPermissionsService _appPermissionsService =
      locator<AppPermissionsService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final InterFaceAppPreferences _preferencesService =
  locator<AppPreferencesService>();
  bool isGalleryPermissionRequired = false, isNotificationPermissionRequired = false;
  void allowPermissions() async {

    Map<Permission, PermissionStatus> appPermissionsStatuses = await _appPermissionsService.requestAppPermissions();

    if(appPermissionsStatuses[Permission.notification] == PermissionStatus.granted){
      locator<PushNotificationsService>().initializePushNotifications();
    }

    back();
  }

  void denyPermissions() async {
    await _appPermissionsService.denyPermissions();
    back();
  }

  back(){
    _preferencesService.shownAppPermissionsOnce(true);
    _navigationService.back();
  }

  checkIfGalleryPermissionRequired() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    AndroidBuildVersion version = androidInfo.version;
    int? sdk = version.sdkInt ?? 29;
    isGalleryPermissionRequired = !(sdk > 29);
  }


}
