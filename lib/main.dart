import 'package:flutter/material.dart';
import 'package:reliefmate/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (context) => const Login(),
    },
  ));
}
