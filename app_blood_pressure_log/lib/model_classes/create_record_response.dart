import 'dart:convert';

class CreateRecordResponse {
  final int id;

  CreateRecordResponse({
    required this.id,
  });

  CreateRecordResponse copyWith({
    int? id,
  }) =>
      CreateRecordResponse(
        id: id ?? this.id,
      );

  factory CreateRecordResponse.fromRawJson(String str) =>
      CreateRecordResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateRecordResponse.fromJson(Map<String, dynamic> json) =>
      CreateRecordResponse(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
