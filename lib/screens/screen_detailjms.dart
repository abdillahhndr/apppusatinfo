// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:apppusatinfo/main.dart';
import 'package:apppusatinfo/models/model_listjms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DetailJmsScreen extends StatefulWidget {
  final Datum? data;

  const DetailJmsScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<DetailJmsScreen> createState() => _DetailJmsScreenState();
}

class _DetailJmsScreenState extends State<DetailJmsScreen> {
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

  void _approve() {
    setState(() {
      _isApproved = true;
      _isRejected = false;
      _isSelecting = false;
    });
  }

  void _reject() {
    setState(() {
      _isRejected = true;
      _isApproved = false;
      _isSelecting = false;
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
                    "Detail JMS",
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
                                widget.data!.sekolah,
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
                            widget.data!.nama,
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // if (widget.data!.status == 'pending')
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 100),
                  //     child: ElevatedButton(
                  //       onPressed: _toggleSelecting,
                  //       style: ElevatedButton.styleFrom(
                  //         primary: Colors.green,
                  //         elevation: 0.0,
                  //         padding:
                  //             EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(40),
                  //         ),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               'Action',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 18,
                  //                 color: Color(0xffF2F2F2),
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.all(10),
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               shape: BoxShape.circle,
                  //             ),
                  //             child: Icon(
                  //               Icons.arrow_forward,
                  //               color: Colors.black,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
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
