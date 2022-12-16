import 'package:flutter/material.dart';
import 'package:reliefmate/services/cloud/cloud_profile.dart';
import 'package:reliefmate/services/cloud/frebase_cloud_storage.dart';
import 'package:reliefmate/views/homeviews/profile_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final FirebaseCloudStorage _cloudStorage;

  @override
  void initState() {
    _cloudStorage = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: StreamBuilder(
            stream: _cloudStorage.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allUsers = snapshot.data as Iterable<CloudProfile>;
                    return ProfileListView(users: allUsers);
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          )),
    );
  }
}
