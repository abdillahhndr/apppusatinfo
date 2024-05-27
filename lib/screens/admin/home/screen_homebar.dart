import 'package:apppusatinfo/screens/admin/home/screen_homeadmin.dart';
import 'package:apppusatinfo/screens/screen_login.dart';
import 'package:apppusatinfo/screens/screen_profile.dart';
import 'package:apppusatinfo/utils/cek_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageHomeAdmin extends StatefulWidget {
  const PageHomeAdmin({Key? key}) : super(key: key);

  @override
  State<PageHomeAdmin> createState() => _PageHomeAdminState();
}

class _PageHomeAdminState extends State<PageHomeAdmin>
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
          HomePageAdmin(),
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
