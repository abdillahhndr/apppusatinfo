// To parse this JSON data, do
//
//     final modelListjms = modelListjmsFromJson(jsonString);

import 'dart:convert';

ModelListjms modelListjmsFromJson(String str) =>
    ModelListjms.fromJson(json.decode(str));

String modelListjmsToJson(ModelListjms data) => json.encode(data.toJson());

class ModelListjms {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListjms({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListjms.fromJson(Map<String, dynamic> json) => ModelListjms(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String sekolah;
  String nama;
  String status;
  String idUser;

  Datum({
    required this.id,
    required this.sekolah,
    required this.nama,
    required this.status,
    required this.idUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sekolah: json["sekolah"],
        nama: json["nama"],
        status: json["status"],
        idUser: json["id_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sekolah": sekolah,
        "nama": nama,
        "status": status,
        "id_user": idUser,
      };
}
