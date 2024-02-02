import 'dart:convert';

class AccountCreateResponse {
  final String? detail;
  final String? otp;

  AccountCreateResponse({
    this.detail,
    this.otp,
  });

  AccountCreateResponse copyWith({
    String? detail,
    String? otp,
  }) =>
      AccountCreateResponse(
        detail: detail ?? this.detail,
        otp: otp ?? this.otp,
      );

  factory AccountCreateResponse.fromJson(String str) =>
      AccountCreateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AccountCreateResponse.fromMap(Map<String, dynamic> json) =>
      AccountCreateResponse(
        detail: json["detail"],
        otp: json["OTP"],
      );

  Map<String, dynamic> toMap() => {
        "detail": detail,
        "OTP": otp,
      };
}
