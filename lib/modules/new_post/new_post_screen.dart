import 'package:flutter/material.dart';

import '../../shared/components/components.dart';

class NewPostsScreen extends StatelessWidget {
  const NewPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  defaultAppBar(context:  context, title: "Add Posts" ),
      body: Center(child: Text("Add Posts")),
    );
  }
}
