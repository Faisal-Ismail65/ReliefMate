import 'package:flutter/material.dart';
import 'package:reliefmate/services/cloud/cloud_profile.dart';
import 'package:reliefmate/services/cloud/frebase_cloud_storage.dart';

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
                    return ListView.builder(
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        final user = allUsers.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ListTile(
                            hoverColor: Colors.red,
                            leading: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.redAccent,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 50,
                              ),
                            ),
                            title: Text(user.name),
                            trailing: Text(user.address),
                          ),
                        );
                      },
                    );
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
