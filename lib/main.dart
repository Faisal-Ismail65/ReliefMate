import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliefmate/firebase_options.dart';
import 'package:reliefmate/models/auth_user.dart';
import 'package:reliefmate/providers/user_provider.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';
import 'package:reliefmate/utilities/widgets/loader.dart';
import 'package:reliefmate/views/adminviews/admin_view.dart';
import 'package:reliefmate/views/authviews/login_view.dart';
import 'package:reliefmate/views/homeviews/bottom_bar_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          backgroundColor: GlobalVariables.appBackgroundColor,
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
  AuthUser? user;
  @override
  void initState() {
    addData();
    super.initState();
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
      if (user?.type == 'admin') {
        return const AdminView();
      } else {
        return const BottomBarView();
      }
    }
  }
}
