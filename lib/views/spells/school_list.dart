

import 'package:flutter/material.dart';

class SchoolListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SchoolListState();

}

class SchoolListState extends State<SchoolListPage> {

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Spell Schools"),
      ),
    );
  }

}
