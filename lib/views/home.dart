import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final tabs = [
    const Center(
      child: Text('Home'),
    ),
    const Center(
      child: Text('Search'),
    ),
    const Center(
      child: Text('Profile'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
          'FYP',
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
                accountName: Text('FaisalIsmail'),
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
                  'About',
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
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        currentIndex: _currentIndex,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person),
              ),
              label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
