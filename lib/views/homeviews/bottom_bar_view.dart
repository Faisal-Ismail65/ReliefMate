// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reliefmate/constants/routes.dart';
import 'package:reliefmate/services/auth/auth_service.dart';
import 'package:reliefmate/utilities/dialogs/logout_dialog.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';
import 'package:reliefmate/views/homeviews/apply_for_relief.dart';
import 'package:reliefmate/views/homeviews/blogs_view.dart';
import 'package:reliefmate/views/homeviews/edit_profile.dart';
import 'package:reliefmate/views/homeviews/home_view.dart';
import 'package:reliefmate/views/homeviews/profile_view.dart';
import 'package:reliefmate/views/homeviews/settings_view.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({super.key});

  @override
  State<BottomBarView> createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  String get _userEmail => AuthService.firebase().currentUser!.email;
  final users = FirebaseFirestore.instance.collection('profiles');
  String get _userId => AuthService.firebase().currentUser!.id;
  var userProfile = {};
  var userData = {};
  bool isLoading = false;
  @override
  void initState() {
    getData();
    getProfilePic();
    super.initState();
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

      userData = userSnap.data()!;
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

    userProfile = userProfileSnap.data()!;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'ReliefMate',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'worksans',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: Drawer(
        width: 230,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                accountName: const Text(''),
                accountEmail: Text(_userEmail),
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
                  color: Colors.redAccent,
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : userData['uid'] == null
                    ? InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return const ApplyForRelief();
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: Icon(Icons.person_add),
                          title: Text(
                            'Apply for Relief',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.redAccent,
                              fontFamily: 'worksans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfile(userData: userData);
                              },
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: Icon(Icons.person_add),
                          title: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.redAccent,
                              fontFamily: 'worksans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingView();
                    },
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  'Setting',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.redAccent,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.redAccent,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginView, (_) => false);
                }
                showSnackBar(context, 'Logged Out Successfully');
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.redAccent,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          iconSize: 35,
          activeColor: Colors.redAccent,
          inactiveColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department_outlined),
              label: 'Blogs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(child: HomeView());
                },
              );
            case 1:
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(child: BlogsVew());
                },
              );
            case 2:
              return CupertinoTabView(
                builder: (context) {
                  return const CupertinoPageScaffold(child: ProfileView());
                },
              );
          }
          return const HomeView();
        },
      ),
    );
  }
}
