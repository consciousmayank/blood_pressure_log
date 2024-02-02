import 'package:device_info_plus/device_info_plus.dart';

class ValidationChecks {
  bool isValidEmail({String? email}) {
    if (email == null) {
      return false;
    }
    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return emailRegex.hasMatch(email);
  }

  Future<bool> isPreAndroid10Version() async{
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    AndroidBuildVersion version = androidInfo.version;
    int? sdk = version.sdkInt ?? 29;
    return sdk > 29;
  }
}
