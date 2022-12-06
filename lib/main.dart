import 'package:flutter/material.dart';
import 'package:reliefmate/constants/routes.dart';
import 'package:reliefmate/views/bottom_bar.dart';
import 'package:reliefmate/views/home.dart';
import 'package:reliefmate/views/login.dart';
import 'package:reliefmate/views/signup.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login(),
    routes: {
      loginView: (context) => const Login(),
      signupView: (context) => const Signup(),
      homeView: (context) => const Home(),
      bottomBarView: (context) => const BottomBar(),
    },
  ));
}
