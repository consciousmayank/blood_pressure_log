import 'dart:convert';

import 'package:app_blood_pressure_log/model_classes/login/login_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked_annotations.dart';

class AppPreferencesService
    implements InterFaceAppPreferences, InitializableDependency {
  late List<int> key;

  late Box appHelperBox;

  final FlutterSecureStorage _sharedPrefs = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      ));

  Future _initPreferences() async {
    String? keyString = await _sharedPrefs.read(key: _preferencesEncryptionKey);

    if (keyString == null) {
      key = Hive.generateSecureKey();
      await _sharedPrefs.write(
        key: _preferencesEncryptionKey,
        value: base64UrlEncode(
          key,
        ),
      );
    } else {
      key = base64Url.decode(keyString);
    }

    //declare hive adapters here
    Hive.registerAdapter(LoginResponseAdapter());
    //declare hive adapters above

    await Hive.initFlutter();
    await _openAppHelperBox();
  }

  Future _openAppHelperBox() async {
    appHelperBox = await Hive.openBox(
      'appHelperBox',
      encryptionCipher: HiveAesCipher(
        key,
      ),
    );
  }

  @override
  Future<void> init() async {
    await _initPreferences();
  }

  @override
  void saveTokens({required LoginResponse? loginResponse}) {
    if (loginResponse == null) {
      appHelperBox.delete(_tokenKey);
    } else {
      appHelperBox.put(_tokenKey, loginResponse);
    }
  }

  @override
  bool isUserLoggedIn() {
    return fetchToken() != null && fetchToken()?.accessToken != null;
  }

  @override
  LoginResponse? fetchToken() {
    LoginResponse? token = appHelperBox.get(_tokenKey, defaultValue: null);
    return token;
  }

  @override
  void logout() {
    appHelperBox.clear();
  }

  @override
  void saveImageToken({required String token}) {
    appHelperBox.put(_imageTokenKey, token);
  }

  @override
  String fetchImageToken() {
    return appHelperBox.get(_imageTokenKey, defaultValue: "");
  }

  @override
  bool isAppIntroShownOnce() {
    return appHelperBox.get(_appIntroOnceKey, defaultValue: false);
  }

  @override
  void shownAppIntroOnce(bool value) {
    appHelperBox.put(_appIntroOnceKey, value);
  }

  @override
  bool isAppPermissionsShownOnce() {
    return appHelperBox.get(_appPermissionsShownOnceKey, defaultValue: false);
  }

  @override
  void shownAppPermissionsOnce(bool value) {
    appHelperBox.put(_appPermissionsShownOnceKey, value);
  }
}

const String _preferencesEncryptionKey = 'preferencesEncryptionKey';
const String _tokenKey = 'tokenKey';
const String _imageTokenKey = 'imageTokenKey';
const String _appIntroOnceKey = 'appIntroOnceKey';
const String _appPermissionsShownOnceKey = 'appPermissionsShownOnceKey';

abstract class InterFaceAppPreferences {
  void saveTokens({required LoginResponse? loginResponse});

  bool isUserLoggedIn();

  LoginResponse? fetchToken();

  void logout();

  void saveImageToken({required String token});
  String fetchImageToken();

  void shownAppIntroOnce(bool value);
  bool isAppIntroShownOnce();

  void shownAppPermissionsOnce(bool value);
  bool isAppPermissionsShownOnce();
}
