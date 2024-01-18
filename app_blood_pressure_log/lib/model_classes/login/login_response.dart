import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../ui/common/hive_type_id.dart';

part 'login_response.g.dart';

@HiveType(typeId: HiveTypeIds.loginResponseId)
class LoginResponse {
  @HiveField(0)
  final String accessToken;
  @HiveField(1)
  final String refreshToken;
  @HiveField(2)
  final String tokenType;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  LoginResponse copyWith({
    String? accessToken,
    String? tokenType,
    String? refreshToken,
  }) =>
      LoginResponse(
        accessToken: accessToken ?? this.accessToken,
        tokenType: tokenType ?? this.tokenType,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "refresh_token": refreshToken,
      };
}
