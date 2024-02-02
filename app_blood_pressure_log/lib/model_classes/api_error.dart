import 'dart:convert';

class ApiError {
  final String detail;

  ApiError({
    required this.detail,
  });

  ApiError copyWith({
    String? detail,
  }) =>
      ApiError(
        detail: detail ?? this.detail,
      );

  factory ApiError.fromJson(String str) => ApiError.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ApiError.fromMap(Map<String, dynamic> json) => ApiError(
        detail: json["detail"],
      );

  Map<String, dynamic> toMap() => {
        "detail": detail,
      };
}
