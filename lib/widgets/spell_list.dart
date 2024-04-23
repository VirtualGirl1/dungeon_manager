

import 'package:flutter/material.dart';

class SpellList extends StatefulWidget {
  const SpellList({super.key, required this.spells});

  final List<Map<String, dynamic>> spells;

  @override
  State<StatefulWidget> createState() => SpellListState();

}

class SpellListState extends State<SpellList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.spells.length,
        itemBuilder: (BuildContext itemBuilder, index) {
          return Card(
            child: ListTile(
              title: Text(widget.spells[index]["name"]),

            ),
          );
        }
    );
  }

}
