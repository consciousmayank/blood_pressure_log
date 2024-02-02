// To parse this JSON data, do
//
//     final records = recordsFromJson(jsonString);

import 'dart:convert';

List<Records> recordsFromJson(String str) =>
    List<Records>.from(json.decode(str).map((x) => Records.fromJson(x)));

String recordsToJson(List<Records> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Records {
  final int? id;
  final int systolicValue;
  final int diastolicValue;
  final DateTime? logDate;
  final String imageUrl;

  Records({
    this.id,
    required this.systolicValue,
    required this.diastolicValue,
    this.logDate,
    required this.imageUrl,
  });

  Records copyWith({
    int? id,
    int? systolicValue,
    int? diastolicValue,
    DateTime? logDate,
    String? imageUrl,
  }) =>
      Records(
        id: id ?? this.id,
        systolicValue: systolicValue ?? this.systolicValue,
        diastolicValue: diastolicValue ?? this.diastolicValue,
        logDate: logDate ?? this.logDate,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory Records.fromJson(Map<String, dynamic> json) => Records(
        id: json["id"],
        systolicValue: json["systolic_value"],
        diastolicValue: json["diastolic_value"],
        logDate: DateTime.parse(json["log_date"]),
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "systolic_value": systolicValue,
        "diastolic_value": diastolicValue,
        "log_date": logDate?.toIso8601String(),
        "image_url": imageUrl,
      };
}
