import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:reliefmate/utilities/utils/utils.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/custom_text_button.dart';
import 'package:reliefmate/utilities/widgets/grid_item.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/views/homeviews/about_view.dart';
import 'package:reliefmate/views/homeviews/create_profile.dart';
import 'package:reliefmate/views/homeviews/donate_view.dart';
import 'package:reliefmate/views/homeviews/donations_view.dart';
import 'package:reliefmate/views/homeviews/notification_view.dart';
import 'package:reliefmate/views/homeviews/profile_view.dart';
import 'package:reliefmate/views/homeviews/request_view.dart';
import 'package:reliefmate/views/homeviews/requests_view.dart';
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

  void getLocation() async {
    final location = await getUserLocation();
    print(location.latitude);
    print(location.longitude);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    Placemark place = placemarks[0];

    String address =
        "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    print(address);
  }

  List<String> path = [
    'assets/images/donate.jpeg',
    'assets/images/donations.jpeg',
    'assets/images/donate.jpeg',
  ];
  @override
  void initState() {
    super.initState();
    getLocation();
    getData();
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
            appBar: SimpleAppBar(
              text: 'ReliefMate',
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NotificationView(),
                    ));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Badge(
                      label: Text('5'),
                      child: const Icon(
                        Icons.notifications_none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: userData['uid'] == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'ReliefMate is created to make sure that victims of disasters get the help they need in an emergency. Natural disasters are a major problem that the world faces today. They can strike at any time and place, without warning. And, when they do, the damage they cause can be absolutely devastating.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'You first have to create your profile to access the full functionality of the application. Once you finish your profile you will be able to donate needy people.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          CustomTextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CreateProfile(),
                                ),
                              );
                            },
                            text: "Click here to Create Profile",
                            underline: false,
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      children: [
                        userData['type'] == 'donor'
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const DonateView(),
                                  ));
                                },
                                child: const GridItem(
                                  path: 'assets/images/donate.jpeg',
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const RequestView(),
                                  ));
                                },
                                child: const GridItem(
                                  path: 'assets/images/request.jpeg',
                                ),
                              ),
                        userData['type'] == 'donor'
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DonationsView(),
                                    ),
                                  );
                                },
                                child: const GridItem(
                                  path: 'assets/images/donations.jpeg',
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RequestsView(),
                                    ),
                                  );
                                },
                                child: const GridItem(
                                  path: 'assets/images/123.jpg',
                                ),
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
                            path: 'assets/images/victims.jpeg',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfileView(),
                              ),
                            );
                          },
                          child: const GridItem(
                            path: 'assets/images/profile.jpeg',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AboutView(),
                            ));
                          },
                          child: const GridItem(
                            path: 'assets/images/about_us.png',
                          ),
                        ),
                      ],
                    )),
          );
  }
}
