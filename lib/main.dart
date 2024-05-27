import 'package:apppusatinfo/screens/screen_detailpepeg.dart';
import 'package:apppusatinfo/screens/screen_home.dart';
import 'package:apppusatinfo/screens/screen_login.dart';
import 'package:apppusatinfo/screens/screen_profile.dart';
import 'package:apppusatinfo/screens/screen_regis.dart';
import 'package:apppusatinfo/screens/screen_splash.dart';
import 'package:apppusatinfo/utils/cek_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: TabBarView(
        controller: tabController,
        children: const [
          HomePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                tabController.animateTo(0); // Home
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                // Gallery
                _showSidebar(); // Call the function to show the sidebar
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.green.shade200,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(CupertinoIcons.person_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.info_circle),
              title: const Text('Tentang Kami'),
              onTap: () {
                // Action when Menu 2 is selected
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                setState(() {
                  session.clearSession();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSidebar() {
    _scaffoldKey.currentState?.openEndDrawer(); // Open the endDrawer
  }
}
