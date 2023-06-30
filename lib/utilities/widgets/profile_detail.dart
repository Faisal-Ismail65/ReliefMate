// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/profile_tile.dart';

class ProfileDetail extends StatefulWidget {
  final UserProfile user;
  const ProfileDetail({super.key, required this.user});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  var userProfile = {};
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    var userProfileSnap = await FirebaseFirestore.instance
        .collection('profilePics')
        .doc(widget.user.uid)
        .get();

    userProfile = userProfileSnap.data() ?? {};
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
          text: widget.user.type == 'victim'
              ? 'Victim Details'
              : 'Donor Details'),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: double.infinity,
                  child: FlutterMap(
                    options: MapOptions(
                      center: LatLng(widget.user.latitude,
                          widget.user.longitude), // London coordinates
                      zoom: 18.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: LatLng(
                                widget.user.latitude,
                                widget.user
                                    .longitude), // Marker coordinates (same as map center in this example)
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: GlobalVariables.appBarBackgroundColor,
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: userProfile['photoUrl'] == null
                        ? const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: GlobalVariables.appBarBackgroundColor,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(userProfile['photoUrl']),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                ProfileTile(fieldName: 'Name', fieldValue: widget.user.name),
                ProfileTile(
                    fieldName: 'Address', fieldValue: widget.user.address),
                ProfileTile(
                    fieldName: 'Phone Number',
                    fieldValue: widget.user.phoneNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
