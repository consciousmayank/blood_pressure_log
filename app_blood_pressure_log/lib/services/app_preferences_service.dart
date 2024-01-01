import 'dart:convert';

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
    // Hive.registerAdapter(StoryResponseAdapter());
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
  void saveToken({required String? token}) {
    if (token == null) {
      appHelperBox.delete(_tokenKey);
    } else {
      appHelperBox.put(_tokenKey, token);
    }
  }

  @override
  bool isUserLoggedIn() {
    String token = appHelperBox.get(_tokenKey, defaultValue: "");
    return token.isNotEmpty;
  }

  @override
  String fetchToken() {
    String token = appHelperBox.get(_tokenKey, defaultValue: "");
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
}

const String _preferencesEncryptionKey = 'preferencesEncryptionKey';
const String _tokenKey = 'tokenKey';
const String _imageTokenKey = '_imageTokenKey';

abstract class InterFaceAppPreferences {
  void saveToken({required String? token});

  bool isUserLoggedIn();

  String fetchToken();

  void logout();

  void saveImageToken({required String token});
  String fetchImageToken();
}
