import 'package:flutter/material.dart';

class BlogsVew extends StatefulWidget {
  const BlogsVew({super.key});

  @override
  State<BlogsVew> createState() => _BlogsVewState();
}

class _BlogsVewState extends State<BlogsVew> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Blogs')),
    );
  }
}
