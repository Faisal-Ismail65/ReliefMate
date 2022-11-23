import 'package:flutter/material.dart';
import 'package:reliefmate/home.dart';
import 'package:reliefmate/login.dart';
import 'package:reliefmate/signup.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Login(),
    routes: {
      'login': (context) => const Login(),
      'signup': (context) => const Signup(),
      'home': (context) => const Home(),
    },
  ));
}
