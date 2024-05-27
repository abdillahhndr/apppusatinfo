// To parse this JSON data, do
//
//     final modelAddphkm = modelAddphkmFromJson(jsonString);

import 'dart:convert';

ModelAddphkm modelAddphkmFromJson(String str) =>
    ModelAddphkm.fromJson(json.decode(str));

String modelAddphkmToJson(ModelAddphkm data) => json.encode(data.toJson());

class ModelAddphkm {
  bool isSuccess;
  String message;

  ModelAddphkm({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddphkm.fromJson(Map<String, dynamic> json) => ModelAddphkm(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
      };
}
