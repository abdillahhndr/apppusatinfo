// ignore_for_file: prefer_const_constructors

import 'package:apppusatinfo/models/model_addjms.dart';
import 'package:apppusatinfo/screens/admin/home/screen_homebar.dart';
import 'package:apppusatinfo/screens/admin/list/screen_listaliranagama.dart';
import 'package:apppusatinfo/screens/admin/list/screen_listjms.dart';
import 'package:apppusatinfo/screens/admin/list/screen_listkorup.dart';
import 'package:apppusatinfo/screens/admin/list/screen_listpepeg.dart';
import 'package:apppusatinfo/screens/admin/list/screen_listphkm.dart';
import 'package:apppusatinfo/screens/admin/list/screen_listpilkada.dart';
import 'package:apppusatinfo/utils/url.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  String? id, username, email;
  TextEditingController txtPesan = TextEditingController();
  bool isLoading = false;
  int userRating = 0;
  final List<String> imageList2 = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
    'assets/images/banner5.png',
  ];

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      email = pref.getString("email") ?? '';
    });
  }

  Future<ModelAddjms?> rating(String rate) async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/rating.php'), body: {
        "pesan": txtPesan.text,
        "id_user": id,
        "rating": rate,
      });
      ModelAddjms data = modelAddjmsFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (data.isSuccess == true) {
        setState(() {
          isLoading = false;
          //pindah ke page login
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PageHomeAdmin()),
              (route) => false);
        });
      } else if (data.isSuccess == false) {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
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
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.green.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    'Beri Penilaian',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                userRating = index + 1;
                              });
                            },
                            child: Icon(
                              index < userRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange.shade300,
                              size: 35,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: txtPesan,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  fillColor: Colors.red,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Comment here...',
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  rating('$userRating');
                                },
                                child: Text('Submit'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset('assets/images/logo.png'),
              SizedBox(height: 10),
              Text(
                'Selamat Datang Admin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  'Pusat Informasi Kejaksaan Tinggi Sumatera Barat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CarouselSlider(
                items: imageList2.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(item),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Container(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                    children: List.generate(6, (index) {
                      List<IconData> icons = [
                        Icons.person,
                        Icons.gavel,
                        Icons.school,
                        Icons.book,
                        Icons.supervised_user_circle,
                        Icons.how_to_vote,
                      ];

                      List<String> labels = [
                        "Pengaduan Pegawai",
                        "Pengaduan Tindak Pidana Korupsi",
                        "JMS (Jaksa Masuk Sekolah)",
                        "Penyuluhan Hukum",
                        "Pengawasan Aliran dan Kepercayaan",
                        "Posko Pilkada",
                      ];

                      return Card(
                        color: Colors.green.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListPengaduanpegawaiAdmin()),
                                );
                                break;
                              case 1:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListKorupAdmin()),
                                );
                                break;
                              case 2:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListJmsAdmin()),
                                );
                                break;
                              case 3:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListPhkmAdmin()),
                                );
                                break;
                              case 4:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ListAliranagamaAdmin()),
                                );
                                break;
                              case 5:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListPoskoAdmin()),
                                );
                                break;
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icons[index], size: 30),
                              SizedBox(height: 10),
                              Text(
                                labels[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
