import 'dart:convert';

AppConfigs appConfigsFromJson(String str) =>
    AppConfigs.fromJson(json.decode(str));

String appConfigsToJson(AppConfigs data) => json.encode(data.toJson());

class AppConfigs {
  final String token;

  AppConfigs({
    required this.token,
  });

  AppConfigs copyWith({
    String? token,
  }) =>
      AppConfigs(
        token: token ?? this.token,
      );

  factory AppConfigs.fromJson(Map<String, dynamic> json) => AppConfigs(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
