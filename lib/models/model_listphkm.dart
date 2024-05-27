// To parse this JSON data, do
//
//     final modelListPhkm = modelListPhkmFromJson(jsonString);

import 'dart:convert';

ModelListPhkm modelListPhkmFromJson(String str) =>
    ModelListPhkm.fromJson(json.decode(str));

String modelListPhkmToJson(ModelListPhkm data) => json.encode(data.toJson());

class ModelListPhkm {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelListPhkm({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListPhkm.fromJson(Map<String, dynamic> json) => ModelListPhkm(
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
  String nama;
  String noHp;
  String nik;
  String fotoKtp;
  String laporan;
  String fotoLaporan;
  String kategori;
  String status;
  String idUser;

  Datum({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.nik,
    required this.fotoKtp,
    required this.laporan,
    required this.fotoLaporan,
    required this.kategori,
    required this.status,
    required this.idUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nama: json["nama"],
        noHp: json["no_hp"],
        nik: json["nik"],
        fotoKtp: json["foto_ktp"],
        laporan: json["laporan"],
        fotoLaporan: json["foto_laporan"],
        kategori: json["kategori"],
        status: json["status"],
        idUser: json["id_user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "no_hp": noHp,
        "nik": nik,
        "foto_ktp": fotoKtp,
        "laporan": laporan,
        "foto_laporan": fotoLaporan,
        "kategori": kategori,
        "status": status,
        "id_user": idUser,
      };
}
