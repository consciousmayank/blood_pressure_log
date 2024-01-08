import 'dart:convert';

class FcmTokenSaveRequest {
  final String token;

  FcmTokenSaveRequest({
    required this.token,
  });

  FcmTokenSaveRequest copyWith({
    String? token,
  }) =>
      FcmTokenSaveRequest(
        token: token ?? this.token,
      );

  factory FcmTokenSaveRequest.fromJson(String str) => FcmTokenSaveRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FcmTokenSaveRequest.fromMap(Map<String, dynamic> json) => FcmTokenSaveRequest(
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "token": token,
  };
}
