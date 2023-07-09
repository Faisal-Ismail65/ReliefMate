import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/models/user_profile.dart';
import 'package:reliefmate/utilities/widgets/application_card.dart';
import 'package:reliefmate/utilities/widgets/custom_text_field.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';

class DisapprovedDonorView extends StatefulWidget {
  const DisapprovedDonorView({super.key});

  @override
  State<DisapprovedDonorView> createState() => _DisapprovedDonorViewState();
}

class _DisapprovedDonorViewState extends State<DisapprovedDonorView> {
  final List<UserProfile> searchedUser = [];
  final TextEditingController _searchController = TextEditingController();
  List<UserProfile> users = [];
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomTextField(
                  onChange: (value) {
                    searchedUser.clear();
                    for (var i in users) {
                      if (i.name
                              .toLowerCase()
                              .startsWith(value.toLowerCase()) ||
                          i.email
                              .toLowerCase()
                              .startsWith(value.toLowerCase())) {
                        searchedUser.add(i);
                      }
                    }
                    setState(() {
                      print("Searching Start");
                      searching = true;
                    });
                  },
                  controller: _searchController,
                  labelText: 'Search',
                  obseureText: false),
            ),
            searching
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: searchedUser.length,
                      itemBuilder: (context, index) {
                        print('Searching List');
                        return ApplicationCard(user: searchedUser[index]);
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('profiles')
                          .where('status', isEqualTo: 'disapproved')
                          .where('type', isEqualTo: 'donor')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            if (snapshot.hasData) {
                              print('Adding Users');
                              users.addAll(snapshot.data!.docs
                                  .map((e) => UserProfile.fromSnap(e)));
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    print('All Users');
                                    final user = UserProfile.fromSnap(
                                        snapshot.data!.docs[index]);
                                    return ApplicationCard(user: user);
                                  },
                                ),
                              );
                            } else {
                              return const Loader();
                            }
                          default:
                            return const Loader();
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
