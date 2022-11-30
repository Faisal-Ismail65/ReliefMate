import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      ),
      drawer: Drawer(
        width: 230,
        child: ListView(
          children: [
            const DrawerHeader(
              padding: EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                accountName: Text('Faisal Ismail'),
                accountEmail: Text('faisalismail@gmail.com'),
                currentAccountPicture: CircleAvatar(),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
              ),
            ),
            ListTile(
              title: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(),
                child: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextButton(
                onPressed: () {},
                child: const Text(
                  'Donate',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: TextButton(
                onPressed: () {},
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.redAccent,
                    fontFamily: 'worksans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: const Text('This is Home'),
    );
  }
}
