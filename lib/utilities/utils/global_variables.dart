import 'package:flutter/material.dart';
import 'package:reliefmate/views/adminviews/applications_view.dart';
import 'package:reliefmate/views/adminviews/approved_applications_view.dart';
import 'package:reliefmate/views/homeviews/blogs_view.dart';
import 'package:reliefmate/views/homeviews/home_view.dart';
import 'package:reliefmate/views/homeviews/profile_view.dart';

List<Widget> homeScreenItems = [
  const BlogsVew(),
  const HomeView(),
  const ProfileView(),
];

List<Widget> adminScreenItems = [
  const Center(
    child: Text('Home'),
  ),
  const ApplicationsView(),
  const ApprovedApplicationsView(),
];
