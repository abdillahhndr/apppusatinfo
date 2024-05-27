// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:apppusatinfo/main.dart';
import 'package:apppusatinfo/models/model_addpegawai.dart';
import 'package:apppusatinfo/models/model_listphkm.dart';
import 'package:apppusatinfo/screens/screen_listphkm.dart';
// import 'package:apppusatinfo/screens/screen_listpepeg.dart';
import 'package:apppusatinfo/utils/url.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditPilkada extends StatefulWidget {
  Datum? data;
  EditPilkada(this.data, {super.key});

  @override
  State<EditPilkada> createState() => _EditPilkadaState();
}

class _EditPilkadaState extends State<EditPilkada> {
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtNohp = TextEditingController();
  TextEditingController txtKTP = TextEditingController();
  TextEditingController txtLaporanPengaduan = TextEditingController();
  // String? _fileName;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  String? id;
  bool isLoading = false;
  File? fileKtp;
  File? fileLaporan;
  void initState() {
    super.initState();
    getSession();
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print(id);
    });
  }

  Future<void> _pickFile(bool isKtp) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isKtp) {
          fileKtp = File(result.files.single
              .path!); // Use File constructor to create File object
        } else {
          fileLaporan = File(result.files.single
              .path!); // Use File constructor to create File object
        }
      });
    }
  }

  Future<void> addpeg(String idp) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (fileKtp != null && fileLaporan != null) {
        var request =
            http.MultipartRequest('POST', Uri.parse('$url/editpengaduan.php'));
        request.fields['nama'] = txtNama.text;
        request.fields['no_hp'] = txtNohp.text;
        request.fields['nik'] = txtKTP.text;
        request.fields['laporan'] = txtLaporanPengaduan.text;
        request.fields['kategori'] = 'poskopilkada';
        request.fields['id_user'] = id!;
        request.fields['id'] = idp;

        request.files.add(await http.MultipartFile.fromPath(
          'foto_ktp',
          fileKtp!.path, // Use the path property of File
        ));

        request.files.add(await http.MultipartFile.fromPath(
          'foto_laporan',
          fileLaporan!.path, // Use the path property of File
        ));

        var res = await request.send();
        var resBody = await http.Response.fromStream(res);
        ModelAddPegawai data = modelAddPegawaiFromJson(resBody.body);

        if (data.isSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ListPhkm()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please upload both files')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
            Text(
              "Edit Posko Pilkada",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            Form(
              key: keyForm,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: txtNama,
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
                    TextFormField(
                      controller: txtNohp,
                      decoration: InputDecoration(
                        fillColor: Colors.green.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: widget.data!.noHp,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: txtKTP,
                      decoration: InputDecoration(
                        fillColor: Colors.green.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: widget.data!.nik,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickFile(true);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                fileKtp != null
                                    ? fileKtp!.path.split('/').last
                                    : widget.data!.fotoKtp,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      maxLines: 4,
                      controller: txtLaporanPengaduan,
                      decoration: InputDecoration(
                        fillColor: Colors.green.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        hintText: widget.data!.laporan,
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickFile(false);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                fileLaporan != null
                                    ? fileLaporan!.path.split('/').last
                                    : widget.data!.fotoLaporan,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            // registerAccount();
                            addpeg(widget.data!.id);
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
                                color:
                                    Colors.white, // Warna latar belakang putih
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
      ),
    );
  }
}
