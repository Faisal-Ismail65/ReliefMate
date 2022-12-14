import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return const Card(
                child: ListTile(
              leading: CircleAvatar(),
              title: Text('Unknown'),
            ));
          },
        ),
      ),
    );
  }
}
