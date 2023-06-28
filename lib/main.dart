// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliefmate/firebase_options.dart';
import 'package:reliefmate/models/auth_user.dart';

import 'package:reliefmate/providers/user_provider.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/utils/utils.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/views/adminviews/admin_view.dart';
import 'package:reliefmate/views/authviews/login_view.dart';
import 'package:reliefmate/views/homeviews/create_profile.dart';
import 'package:reliefmate/views/homeviews/home_view.dart';

import 'utilities/utils/notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ReleifMate',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: GlobalVariables.appBarColor,
            foregroundColor: Colors.white,
            toolbarTextStyle: TextStyle(
              color: GlobalVariables.textColor,
            ),
            iconTheme: IconThemeData(
              color: GlobalVariables.textColor,
              size: 30,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Home();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const LoginView();
          },
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  late AuthUser user;
  late DocumentSnapshot userProfile;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    permissionHandler();
    getUserLocation();
    addData();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() async {
    LocalNotificationService.initialize();
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //  This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data ${message.data}");
          }
        }
      },
    );

    // This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');
          print(message.notification!.title);
          LocalNotificationService.createAndDisplayNotification(message);
        }
      },
    );

    //  This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        print(
            "FirebaseMessaging.onMessageOpenedApp.listen App is Running in Background");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data ${message.data}");
        }
      },
    );
  }

  addData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
    user = userProvider.getUser;
    userProfile = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .get();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Loader();
    } else {
      if (user.type == 'admin') {
        return const AdminView();
      } else {
        if (userProfile.data() == null) {
          return const CreateProfile();
        } else {
          return const HomeView();
        }
      }
    }
  }
}
