import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? idUser, userName, email, nik, alamat, notlp;

  Future<void> saveSession(int val, String id, String userName, String email,
      String nik, String alamat, String notlp) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id", id);
    pref.setString("username", userName);
    pref.setString("email", email);
    pref.setString("nik", nik);
    pref.setString("alamat", alamat);
    pref.setString("no_tlp", notlp);
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id");
    pref.getString("username");
    return value;
  }

  Future getSesiIdUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("id");
    return idUser;
  }

  //clear session --> logout
  Future clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();
