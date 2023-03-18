// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';
import 'package:reliefmate/utilities/dialogs/logout_dialog.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/drawer_menu_tile.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/authviews/login_view.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _userEmail = FirebaseAuth.instance.currentUser!.email;
  late PageController adminPageController;
  var _page = 0;

  @override
  void initState() {
    adminPageController = PageController();
    super.initState();
  }

  void navigationTapped(int page) {
    adminPageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(text: "ReliefMate Admin"),
      drawer: Drawer(
        width: 230,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                accountName: const Text(''),
                accountEmail: Text(_userEmail.toString()),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: GlobalVariables.appBarColor,
                ),
              ),
            ),
            DrawerMenuTile(
              text: 'Setting',
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
            DrawerMenuTile(
              text: 'About',
              icon: const Icon(Icons.info),
              onPressed: () {},
            ),
            DrawerMenuTile(
              text: 'Logout',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthMethods().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                  showSnackBar(context, 'Logged Out Successfully');
                }
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: adminPageController,
        onPageChanged: (value) {
          setState(() {
            _page = value;
          });
        },
        children: adminScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _page == 0
                  ? GlobalVariables.btnBackgroundColor
                  : GlobalVariables.appBarBackgroundColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_fire_department_outlined,
              color: _page == 1
                  ? GlobalVariables.btnBackgroundColor
                  : GlobalVariables.appBarBackgroundColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics_outlined,
              color: _page == 2
                  ? GlobalVariables.btnBackgroundColor
                  : GlobalVariables.appBarBackgroundColor,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
