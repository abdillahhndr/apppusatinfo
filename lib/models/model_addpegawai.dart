// To parse this JSON data, do
//
//     final modelAddPegawai = modelAddPegawaiFromJson(jsonString);

import 'dart:convert';

ModelAddPegawai modelAddPegawaiFromJson(String str) =>
    ModelAddPegawai.fromJson(json.decode(str));

String modelAddPegawaiToJson(ModelAddPegawai data) =>
    json.encode(data.toJson());

class ModelAddPegawai {
  bool isSuccess;
  String message;

  ModelAddPegawai({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPegawai.fromJson(Map<String, dynamic> json) =>
      ModelAddPegawai(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
      };
}
