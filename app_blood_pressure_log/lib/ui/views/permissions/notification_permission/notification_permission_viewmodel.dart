// CameraPermissionViewModel

import 'package:device_info_plus/device_info_plus.dart';
import 'package:stacked/stacked.dart';

class NotificationPermissionViewModel extends FutureViewModel<bool> {
  Future<bool> checkIfNotificationPermissionRequired() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    AndroidBuildVersion version = androidInfo.version;
    int? sdk = version.sdkInt ?? 29;
    return (sdk > 29);
  }

  @override
  void onError(error) {
  }

  @override
  Future<bool> futureToRun() => checkIfNotificationPermissionRequired();
}