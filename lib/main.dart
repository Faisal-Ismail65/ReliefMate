import 'package:flutter/material.dart';
import 'package:reliefmate/constants/routes.dart';
import 'package:reliefmate/services/auth/auth_service.dart';
import 'package:reliefmate/views/adminviews/admin_view.dart';
import 'package:reliefmate/views/homeviews/apply_for_relief.dart';
import 'package:reliefmate/views/homeviews/blogs_view.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';
import 'package:reliefmate/views/authviews/login_view.dart';
import 'package:reliefmate/views/authviews/register_view.dart';
import 'package:reliefmate/views/homeviews/home_view.dart';
import 'package:reliefmate/views/homeviews/profile_view.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    routes: {
      loginView: (context) => const LoginView(),
      signupView: (context) => const RegisterView(),
      bottomBarView: (context) => const BottomBarView(),
      blogsView: (context) => const BlogsVew(),
      homeView: (context) => const HomeView(),
      profileView: (context) => const ProfileView(),
      applyForRelief: (context) => const ApplyForRelief(),
      adminView: (context) => const AdminView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: ((context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              return const BottomBarView();
            }
            return const LoginView();
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      }),
    );
  }
}
