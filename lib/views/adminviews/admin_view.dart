// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';
import 'package:reliefmate/utilities/dialogs/logout_dialog.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/drawer_menu_tile.dart';
import 'package:reliefmate/utilities/widgets/grid_item.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/adminviews/donation_view.dart';
import 'package:reliefmate/views/adminviews/donor_view.dart';
import 'package:reliefmate/views/adminviews/victims_view.dart';
import 'package:reliefmate/views/authviews/login_view.dart';
import 'package:reliefmate/views/homeviews/about_view.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final _userEmail = FirebaseAuth.instance.currentUser!.email;
  late PageController adminPageController;

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
      appBar: const SimpleAppBar(text: "Admin"),
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AboutView(),
                ));
              },
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
      body: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DonorView(),
              ));
            },
            child: const GridItem(
              height: 60,
              width: 60,
              path: 'assets/icons/donate.svg',
              text: 'Donors',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DonationView(),
              ));
            },
            child: const GridItem(
              height: 90,
              width: 80,
              path: 'assets/icons/donation.svg',
              text: 'Donations',
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const VictimsView(),
              ));
            },
            child: const GridItem(
              height: 60,
              width: 70,
              path: 'assets/icons/victims.svg',
              text: 'Victims',
            ),
          ),
          InkWell(
            onTap: () {},
            child: const GridItem(
              height: 90,
              width: 80,
              path: 'assets/icons/product.svg',
              text: 'Stock',
            ),
          ),
        ],
      ),
    );
  }
}
