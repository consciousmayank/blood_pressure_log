// CameraPermissionViewModel

import 'package:device_info_plus/device_info_plus.dart';
import 'package:stacked/stacked.dart';

class GalleryPermissionViewModel extends FutureViewModel<bool> {
  Future<bool> checkIfGalleryPermissionRequired() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    AndroidBuildVersion version = androidInfo.version;
    int? sdk = version.sdkInt ?? 29;
    return !(sdk > 29);
  }

  @override
  void onError(error) {
  }

  @override
  Future<bool> futureToRun() => checkIfGalleryPermissionRequired();
}