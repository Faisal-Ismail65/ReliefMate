import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reliefmate/utilities/utils/global_variables.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late PageController adminPageController;
  var _page = 0;

  @override
  void initState() {
    adminPageController = PageController();
    super.initState();
  }

  void navigationTapped(int page) {
    adminPageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'ReliefMate',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'worksans',
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: PageView(
        controller: adminPageController,
        onPageChanged: (value) {
          setState(() {
            _page = value;
          });
        },
        children: adminScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: _page == 0 ? Colors.redAccent : Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_fire_department_outlined,
              color: _page == 1 ? Colors.redAccent : Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics_outlined,
              color: _page == 2 ? Colors.redAccent : Colors.black,
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
