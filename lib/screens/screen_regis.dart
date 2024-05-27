// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:apppusatinfo/models/model_regis.dart';
import 'package:apppusatinfo/screens/screen_login.dart';
import 'package:apppusatinfo/utils/url.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisPage extends StatefulWidget {
  const RegisPage({super.key});

  @override
  State<RegisPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  TextEditingController txtNama = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNotlp = TextEditingController();
  TextEditingController txtKtp = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;
  bool _isObscure = true;

  Future<ModelRegister?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res =
          await http.post(Uri.parse('$url/register.php'), body: {
        "username": txtNama.text,
        "email": txtEmail.text,
        "no_tlp": txtNotlp.text,
        "alamat": txtAlamat.text,
        "nik": txtKtp.text,
        "password": txtPassword.text,
      });
      ModelRegister data = modelRegisterFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value 2 (email sudah terdaftar),1 (berhasil),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
          //pindah ke page login
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
        });
      } else if (data.value == 2) {
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(34),
            child: Form(
              key: keyForm,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    decoration: BoxDecoration(
                        color: Color(0xffF2F2F2),
                        borderRadius: BorderRadius.circular(50)),
                    alignment: Alignment.topLeft,
                    child: Center(),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Image.asset(
                          'assets/images/logo2.png',
                          height: 170,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: txtNama,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'Nama',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: txtEmail,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'Email',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: txtNotlp,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'No. Telepon',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: txtKtp,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'NIK',
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: txtPassword,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'Password',
                            suffixIcon: IconButton(
                              icon: _isObscure
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: txtAlamat,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            hintText: 'Alamat',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (keyForm.currentState?.validate() == true) {
                              //kita panggil function register
                              registerAccount();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Sign Up',
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
                                  color: Colors
                                      .white, // Warna latar belakang putih
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
                        SizedBox(
                          height: 23,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Already have an Account?  ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                    text: "Sign In",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()));
                                      },
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ))
                              ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
