// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/services/auth/auth_methods.dart';
import 'package:reliefmate/utilities/dialogs/logout_dialog.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/drawer_menu_tile.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/authviews/login_view.dart';
import 'package:reliefmate/views/homeviews/create_profile.dart';
import 'package:reliefmate/views/homeviews/edit_profile.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  final _userEmail = FirebaseAuth.instance.currentUser!.email;
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  var userProfile = {};
  var userData = {};
  bool isLoading = false;
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    getData();
    getProfilePic();
    super.initState();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(_userId)
          .get();

      userData = userSnap.data() ?? {};
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  getProfilePic() async {
    setState(() {
      isLoading = true;
    });
    var userProfileSnap = await FirebaseFirestore.instance
        .collection('profilePics')
        .doc(_userId)
        .get();

    userProfile = userProfileSnap.data() ?? {};
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(
        text: 'ReliefMate',
      ),
      drawer: Drawer(
        width: 230,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  DrawerHeader(
                    padding: const EdgeInsets.all(0),
                    child: UserAccountsDrawerHeader(
                      accountName: const Text(''),
                      accountEmail: Text(_userEmail.toString()),
                      currentAccountPicture: userProfile['photoUrl'] == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.black,
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                userProfile['photoUrl'],
                              ),
                            ),
                      decoration: const BoxDecoration(
                        color: GlobalVariables.appBarColor,
                      ),
                    ),
                  ),
                  userData['status'] == 'disapproved'
                      ? DrawerMenuTile(
                          text: 'Profile Disapproved',
                          icon: const Icon(Icons.person),
                          onPressed: () {},
                        )
                      : userData['uid'] == null
                          ? DrawerMenuTile(
                              text: 'Create Profile',
                              icon: const Icon(Icons.person_add),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const CreateProfile();
                                    },
                                  ),
                                );
                              },
                            )
                          : DrawerMenuTile(
                              text: 'Edit Profile',
                              icon: const Icon(Icons.person_add),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditProfile(userData: userData);
                                    },
                                  ),
                                );
                              },
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
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            _page = value;
          });
        },
        children: homeScreenItems,
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
              Icons.person_outline,
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
