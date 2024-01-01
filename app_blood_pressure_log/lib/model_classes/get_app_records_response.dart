import 'dart:convert';

import 'package:app_blood_pressure_log/model_classes/record.dart';

List<Records> getAllRecordsFromJson(String str) =>
    List<Records>.from(json.decode(str).map((x) => Records.fromJson(x)));

String RecordsToJson(List<Records> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
