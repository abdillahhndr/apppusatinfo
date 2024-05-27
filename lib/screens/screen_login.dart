// ignore_for_file: prefer_const_constructors

import 'package:apppusatinfo/main.dart';
import 'package:apppusatinfo/models/model_login.dart';
import 'package:apppusatinfo/screens/admin/home/screen_homebar.dart';
import 'package:apppusatinfo/screens/screen_home.dart';
import 'package:apppusatinfo/screens/screen_regis.dart';
import 'package:apppusatinfo/utils/cek_session.dart';
import 'package:apppusatinfo/utils/url.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool _isObscure = true;
  bool isLoading = false;

  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/login.php'), body: {
        "email": txtEmail.text,
        "password": txtPassword.text,
      });
      ModelLogin data = modelLoginFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value ,1 (ada data login),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          //save session
          session.saveSession(
              data.value ?? 0,
              data.id ?? "",
              data.username ?? "",
              data.email ?? "",
              data.nik ?? "",
              data.alamat ?? "",
              data.noTlp ?? "");

          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          //pindah ke page berita
          if (data.isAdmin == "0") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PageHome()),
                (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PageHomeAdmin()),
                (route) => false);
          }
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
                          'assets/images/logo3.png',
                          height: 250,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign In",
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
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (keyForm.currentState?.validate() == true) {
                              //kita panggil function register
                              // registerAccount();
                              loginAccount();
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
                                  'Sign In',
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
                              text: "Don’t have an Account?  ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                    text: "Sign Up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisPage()));
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
