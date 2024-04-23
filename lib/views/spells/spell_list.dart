import 'package:dungeon_manager/services/dnd_service.dart';
import 'package:flutter/material.dart';

import '../../widgets/spell_list.dart';

class SpellListPage extends StatefulWidget {
  const SpellListPage({super.key, required this.schoolName});

  final String schoolName;

  @override
  State<StatefulWidget> createState() => SpellListPageState();
}

class SpellListPageState extends State<SpellListPage> {
  DndService dndService = DndService();

  late List<Map<String, dynamic>> spells = [];

  @override
  void initState() {
    super.initState();
    loadSpells();
  }

  loadSpells() async {
    spells = await dndService.getSpellsBySchool(widget.schoolName);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.schoolName} Spells"),
      ),
      body: Center(
        child: SpellList(
          spells: spells,
        ),
      )
    );
  }
}