import 'package:flutter/material.dart';

class NewPostsScreen extends StatelessWidget {
  const NewPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Posts"),
      ),
      body: Center(child: Text("Add Posts")),
    );
  }
}
