import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/custom_text_button.dart';
import 'package:reliefmate/utilities/widgets/grid_item.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/views/homeviews/create_profile.dart';
import 'package:reliefmate/views/homeviews/donate_view.dart';
import 'package:reliefmate/views/homeviews/donations_view.dart';
import 'package:reliefmate/views/homeviews/victims_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  var userData = {};
  bool isLoading = false;

  @override
  void initState() {
    getData();
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

      userData = userSnap.data() ?? {};
      setState(() {});
    } catch (e) {
      e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  userData['uid'] == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  'Welcome to ReliefMate',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.appBarColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'ReliefMate is created to make sure that victims of disasters get the help they need in an emergency. Natural disasters are a major problem that the world faces today. They can strike at any time and place, without warning. And, when they do, the damage they cause can be absolutely devastating.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        GlobalVariables.appBarBackgroundColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'You first have to create your profile to access the full functionality of the application. Once you finish your profile you will be able to donate needy people.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        GlobalVariables.appBarBackgroundColor,
                                  ),
                                ),
                                CustomTextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateProfile(),
                                        ),
                                      );
                                    },
                                    text: "Click here to Create Profile",
                                    underline: false)
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  userData['type'] == 'donor'
                      ? GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const DonateView(),
                                ));
                              },
                              child: const GridItem(
                                  height: 60,
                                  width: 60,
                                  path: 'assets/icons/donate.svg',
                                  text: 'Donate'),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const DonationsView(),
                                  ),
                                );
                              },
                              child: const GridItem(
                                  height: 60,
                                  width: 70,
                                  path: 'assets/icons/donation.svg',
                                  text: 'Donations'),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const VictimsView(),
                                  ),
                                );
                              },
                              child: const GridItem(
                                  height: 60,
                                  width: 70,
                                  path: 'assets/icons/victims.svg',
                                  text: 'Victims'),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
  }
}
