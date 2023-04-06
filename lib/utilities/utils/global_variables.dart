import 'package:flutter/material.dart';
import 'package:reliefmate/views/adminviews/pending_applications_view.dart';
import 'package:reliefmate/views/adminviews/approved_applications_view.dart';
import 'package:reliefmate/views/homeviews/home_view.dart';
import 'package:reliefmate/views/homeviews/victims_view.dart';
import 'package:reliefmate/views/homeviews/profile_view.dart';

class GlobalVariables {
  static const appBarColor = Color.fromRGBO(0, 48, 135, 1);
  static const btnBackgroundColor = Color.fromRGBO(1, 33, 105, 1);
  static const appBarBackgroundColor = Color.fromRGBO(0, 156, 222, 1);
  static const textColor = Colors.white;
  static const appBackgroundColor = Color.fromRGBO(246, 247, 248, 1);
}

List<Widget> homeScreenItems = [
  const HomeView(),
  const ProfileView(),
];

List<Widget> adminScreenItems = [
  const Center(
    child: Text('Home'),
  ),
  const PendingApplicationsView(),
  const ApprovedApplicationsView(),
];
