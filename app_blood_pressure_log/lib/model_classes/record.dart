import 'dart:convert';

class Records {
  final int? id;
  final int systolicValue;
  final int diastolicValue;
  final DateTime? logTime;
  final String imageUrl;

  Records({
    this.id,
    required this.systolicValue,
    required this.diastolicValue,
    this.logTime,
    required this.imageUrl,
  });

  Records copyWith({
    int? id,
    int? systolicValue,
    int? diastolicValue,
    DateTime? logTime,
    String? imageUrl,
  }) =>
      Records(
        id: id ?? this.id,
        systolicValue: systolicValue ?? this.systolicValue,
        diastolicValue: diastolicValue ?? this.diastolicValue,
        logTime: logTime ?? this.logTime,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Records.fromRawJson(String str) => Records.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Records.fromJson(Map<String, dynamic> json) => Records(
        id: json["id"],
        systolicValue: json["systolic_value"],
        diastolicValue: json["diastolic_value"],
        logTime: DateTime.parse(json["log_time"]),
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "systolic_value": systolicValue,
        "diastolic_value": diastolicValue,
        "log_time": logTime?.toIso8601String(),
        "image_url": imageUrl,
      };

  Map<String, dynamic> toCreateRecordJson() => {
        "systolic_value": systolicValue,
        "diastolic_value": diastolicValue,
      };
}
