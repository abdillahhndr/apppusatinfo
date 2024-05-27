// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:apppusatinfo/main.dart';
import 'package:apppusatinfo/models/model_listpengpeg.dart';
import 'package:apppusatinfo/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

class DetailPengaduanScreen extends StatefulWidget {
  final Datum? data;

  const DetailPengaduanScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<DetailPengaduanScreen> createState() => _DetailPengaduanScreenState();
}

class _DetailPengaduanScreenState extends State<DetailPengaduanScreen> {
  bool _isSelecting = false;
  bool _isApproved = false;
  bool _isRejected = false;

  void _toggleSelecting() {
    setState(() {
      _isSelecting = !_isSelecting;
      _isApproved = false;
      _isRejected = false;
    });
  }

  void openPDF(BuildContext context, String pdfPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(
          filePath: pdfPath,
        ),
      ),
    );
  }

  Future<String> _downloadFile(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String fileName = url.split('/').last;
    final File file = File('$tempPath/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

// Gunakan function ini di dalam onPressed dari tombol ElevatedButton ElevatedButton( onPressed: () { openPDF(context, 'path/to/your/pdf.pdf'); }, style: ElevatedButton.styleFrom( padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), primary: Colors.green[200], shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8), ), ), child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.file_copy), ], ), )
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back)),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Detail Pengaduan Pegawai",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.data!.nama,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.data!.laporan,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (widget.data!.status == 'pending')
                            Text(
                              'pending',
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey),
                            ),
                          if (widget.data!.status == 'approve')
                            Text(
                              'approved',
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.green),
                            ),
                          if (widget.data!.status == 'reject')
                            Text(
                              'rejected',
                              style: TextStyle(
                                  fontSize: 14, height: 1.5, color: Colors.red),
                            ),
                          SizedBox(height: 32),
                          Text(
                            'KTP',
                            style: TextStyle(fontSize: 14, height: 1.5),
                          ),
                          SizedBox(height: 10),
                          FutureBuilder<String>(
                            future: _downloadFile(
                                '$url/uploads/ktp/${widget.data!.fotoKtp}'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: 400,
                                    child: PDFView(
                                      filePath: snapshot.data,
                                    ),
                                  );
                                } else {
                                  return Text('Gagal memuat gambar KTP');
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              openPDF(context,
                                  '$url/uploads/ktp/${widget.data!.fotoKtp}');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              primary: Colors.green[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_copy),
                                Column(
                                  children: [Text(widget.data!.fotoKtp)],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Laporan',
                            style: TextStyle(fontSize: 14, height: 1.5),
                          ),
                          SizedBox(height: 10),
                          FutureBuilder<String>(
                            future: _downloadFile(
                                '$url/uploads/laporan/${widget.data!.fotoLaporan}'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: 400,
                                    child: PDFView(
                                      filePath: snapshot.data,
                                    ),
                                  );
                                } else {
                                  return Text('Gagal memuat gambar KTP');
                                }
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              openPDF(context,
                                  'http://192.168.126.1/apipusatinfo/uploads/ktp/${widget.data!.fotoLaporan}');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              primary: Colors.green[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.file_copy),
                                Column(
                                  children: [Text(widget.data!.fotoLaporan)],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Visibility(
                    visible: _isSelecting,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child: const Text('Approve'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
