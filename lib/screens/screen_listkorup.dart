import 'dart:convert';

import 'package:apppusatinfo/main.dart';
import 'package:apppusatinfo/models/model_listkorup.dart';
import 'package:apppusatinfo/screens/edit/screen_editkorup.dart';
import 'package:apppusatinfo/screens/screen_detailkorup.dart';
import 'package:apppusatinfo/screens/screen_pengaduankorup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apppusatinfo/utils/url.dart';

class ListKorup extends StatefulWidget {
  const ListKorup({super.key});

  @override
  State<ListKorup> createState() => _ListKorupState();
}

class _ListKorupState extends State<ListKorup> {
  late List<Datum> _allJms = [];
  bool isLoading = false;
  String? id;
  Future<List<Datum>?> getJms() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(Uri.parse('$url/korupsi.php'), body: {
        "id_user": id,
      });
      List<Datum> data = modelListKorupFromJson(res.body).data ?? [];
      setState(() {
        _allJms = data;
      });
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('data belum ada')));
      });
    }
  }

  Future<void> refreshData() async {
    await getJms(); // Panggil fungsi untuk mengambil data terbaru
    setState(() {}); // Memperbarui state untuk memicu pembangunan ulang widget
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      print(id);
    });
  }

  String baseUrl = '$url';
  Future<void> deleteData(String id) async {
    // Replace with your actual API endpoint
    final url = Uri.parse('$baseUrl/hapuskorup.php');

    // Prepare the POST body with the ID
    final Map<String, String> data = {'id': id};

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['status'] == 'success') {
          print('Data deleted successfully!');
        } else {
          print('Failed to delete data: ${decodedResponse['message']}');
        }
      } else {
        // Handle unsuccessful responses (e.g., network errors, server errors)
        print('Error deleting data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions (e.g., network connection issues)
      print('Error deleting data: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession().then((_) => {getJms()});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageHome()));
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
            "List Pengaduan Tindak Pidana Korupsi",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allJms.length,
              itemBuilder: (context, index) {
                Datum? data = _allJms[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailKorup(data)));
                    },
                    child: Card(
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
                                  '${data?.nama}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (data.status == 'pending')
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditKorup(data)));
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    SizedBox(width: 8),
                                    if (data.status == 'pending')
                                      IconButton(
                                        onPressed: () async {
                                          final idToDelete =
                                              '${data.id}'; // Replace with the ID to delete
                                          await deleteData(idToDelete);
                                          getJms();
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${data?.laporan}',
                              maxLines: 3,
                              style: TextStyle(fontSize: 14, height: 1.5),
                            ),
                            if (data.status == 'pending')
                              Text(
                                'pending',
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.grey),
                              ),
                            if (data.status == 'approve')
                              Text(
                                'approved',
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.green),
                              ),
                            if (data.status == 'reject')
                              Text(
                                'rejected',
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.red),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PengaduankorupPage()));
          },
          splashColor: Colors.green,
          // elevation: 0,
          backgroundColor: Colors.green,
          mini: true,
          child: const Icon(
            Icons.add,
            size: 24,
          ),
        ),
      ),
    );
  }
}
