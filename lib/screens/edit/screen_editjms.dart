// ignore_for_file: prefer_const_constructors

import 'package:apppusatinfo/main.dart';
import 'package:apppusatinfo/models/model_addjms.dart';
import 'package:apppusatinfo/models/model_listjms.dart';
import 'package:apppusatinfo/screens/screen_listjms.dart';
import 'package:apppusatinfo/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditJms extends StatefulWidget {
  Datum? data;
  EditJms(this.data, {super.key});

  @override
  State<EditJms> createState() => _EditJmsState();
}

class _EditJmsState extends State<EditJms> {
  TextEditingController txtSekolah = TextEditingController();
  TextEditingController txtNama = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  String? id;
  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      id = pref.getString("id") ?? '';
      print(id);
    });
  }

  Future<ModelAddjms?> addjms(String idj) async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/editjms.php'), body: {
        "nama": txtNama.text,
        "sekolah": txtSekolah.text,
        "id_user": id,
        "id": idj,
      });
      ModelAddjms data = modelAddjmsFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          //pindah ke page login
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ListJms()),
              (route) => false);
        });
      } else if (data.isSuccess == false) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                ),
              ),
            ],
          ),
          Text("Edit Jaksa Masuk Sekolah",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              )),
          Form(
            key: keyForm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: txtSekolah,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.green.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      hintText: widget.data!.sekolah,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: txtNama,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.green.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      hintText: widget.data!.nama,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: ElevatedButton(
                      onPressed: () {
                        if (keyForm.currentState?.validate() == true) {
                          //kita panggil function register
                          addjms(widget.data!.id);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 0.0,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Submit',
                              textAlign: TextAlign.center, // Tetap tengah
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xffF2F2F2),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white, // Warna latar belakang putih
                              shape: BoxShape.circle, // Bentuk bulat
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.black, // Warna ikon hitam
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
