// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/services/profile/firestore_methods.dart';
import 'package:reliefmate/utilities/widgets/snack_bar.dart';

class EditProfile extends StatefulWidget {
  final userData;
  const EditProfile({super.key, required this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _cnic = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final _editProfileKey = GlobalKey<FormState>();
  final _userId = FirebaseAuth.instance.currentUser!.uid;
  String category = 'Medicine';
  List<String> needs = [
    'Edibles',
    'Wearables',
    'Residence',
    'Medicine',
  ];

  @override
  void initState() {
    _name.text = widget.userData['name'];
    _cnic.text = widget.userData['cnic'];
    _phoneNumber.text = widget.userData['phoneNumber'];
    _address.text = widget.userData['address'];
    category = widget.userData['need'];
    super.initState();
  }

  void editProfile() async {
    bool isForm = _name.text.isNotEmpty &&
        _cnic.text.isNotEmpty &&
        _phoneNumber.text.isNotEmpty &&
        _address.text.isNotEmpty;
    if (isForm) {
      if (_editProfileKey.currentState!.validate()) {
        String res = await FirestoreMethods().updateProfile(
          uid: _userId,
          name: _name.text,
          cnic: _cnic.text,
          phoneNumber: _phoneNumber.text,
          address: _address.text,
          need: category,
        );
        if (res == 'Success') {
          Navigator.of(context).pop();
          showSnackBar(context, 'Your Profile Is Updated Succesfully');
        }
      }
    } else {
      showSnackBar(context, "Please fill all fields!");
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _cnic.dispose();
    _phoneNumber.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        backgroundColor: Colors.redAccent,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'worksans',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: editProfile,
            icon: const Icon(
              Icons.done,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _editProfileKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Enter Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _cnic,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Enter CNIC',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _phoneNumber,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _address,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Enter Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  iconSize: 20,
                  hint: const Text(
                    'Need',
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                  items: needs.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
