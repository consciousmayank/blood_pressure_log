import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked_annotations.dart';

class AppPermissionsService implements InitializableDependency {
  static Map<Permission, PermissionStatus> _statuses = {};

  Map<Permission, PermissionStatus> get statuses => _statuses;

  late Map<Permission, PermissionStatus> appPermissionsStatuses;

  late final List<Permission> appPermissions;

  PermissionStatus getPermissionFor({required Permission permission}) {
    if (appPermissions.contains(permission)) {
      return appPermissionsStatuses[permission] ?? PermissionStatus.denied;
    } else {
      return PermissionStatus.denied;
    }
  }

  Future denyPermissions() async {
    appPermissionsStatuses.forEach((key, value) {
      appPermissionsStatuses[key] = PermissionStatus.denied;
    });
  }

  bool arePermissionsGranted() {
    if (appPermissionsStatuses.isEmpty) {
      return false;
    } else {
      for (PermissionStatus singlePermissionStatus
          in appPermissionsStatuses.values) {
        if (singlePermissionStatus == PermissionStatus.denied) {
          return false;
        }
      }

      return true;
    }
  }

  /// Request the permissions which are selected by user.
  // Future<Map<Permission, PermissionStatus>> requestAppPermissions() async {
  Future<Map<Permission, PermissionStatus>> requestAppPermissions() async {
    appPermissionsStatuses = await appPermissions.request();
    return appPermissionsStatuses;
  }

  @override
  Future<void> init() async {
    appPermissionsStatuses = {};

    if (Platform.isIOS) {
      appPermissions = [Permission.camera, Permission.photos, Permission.notification];
      _statuses = {
        Permission.camera: PermissionStatus.denied,
        Permission.photos: PermissionStatus.denied,
        Permission.notification: PermissionStatus.denied,
      };
    } else {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      AndroidBuildVersion version = androidInfo.version;
      int? sdk = version.sdkInt ?? 29;

      if (sdk > 29) {
        _statuses = {
          Permission.camera: PermissionStatus.denied,
          Permission.notification: PermissionStatus.denied,
        };
        appPermissions = [Permission.camera, Permission.notification];
      } else {
        _statuses = {
          Permission.camera: PermissionStatus.denied,
          Permission.storage: PermissionStatus.denied,
          Permission.notification: PermissionStatus.granted,
        };
        appPermissions = [Permission.camera, Permission.storage];
      }
    }
  }
}
