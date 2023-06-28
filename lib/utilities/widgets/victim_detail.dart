// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/app_bar.dart';
import 'package:reliefmate/utilities/widgets/profile_tile.dart';

class VictimDetail extends StatefulWidget {
  final snap;
  const VictimDetail({super.key, this.snap});

  @override
  State<VictimDetail> createState() => _VictimDetailState();
}

class _VictimDetailState extends State<VictimDetail> {
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
        .doc(widget.snap['uid'])
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
          text: widget.snap['type'] == 'victim'
              ? 'Victim Details'
              : 'Donor Details'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Container(
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
                      backgroundImage: NetworkImage(userProfile['photoUrl']),
                    ),
            ),
            ProfileTile(fieldName: 'Name', fieldValue: widget.snap['name']),
            ProfileTile(
                fieldName: 'Address', fieldValue: widget.snap['address']),
            ProfileTile(
                fieldName: 'Phone Number',
                fieldValue: widget.snap['phoneNumber']),
            Visibility(
              visible: widget.snap['accountNumber'] != '',
              child: ProfileTile(
                  fieldName: 'Account Number',
                  fieldValue: widget.snap['accountNumber']),
            ),
            Visibility(
                visible: widget.snap['need'] != '',
                child: ProfileTile(
                    fieldName: 'Need', fieldValue: widget.snap['need'])),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 370,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  center:
                      LatLng(37.4219991, -122.0840012), // London coordinates
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
                        point: LatLng(37.4219991,
                            -122.0840012), // Marker coordinates (same as map center in this example)
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
          ],
        ),
      ),
    );
  }
}
