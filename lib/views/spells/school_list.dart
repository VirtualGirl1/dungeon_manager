

import 'package:dungeon_manager/services/DndService.dart';
import 'package:dungeon_manager/views/spells/create_school.dart';
import 'package:flutter/material.dart';

class SchoolListPage extends StatefulWidget {
  const SchoolListPage({super.key});

  @override
  State<StatefulWidget> createState() => SchoolListState();

}

class SchoolListState extends State<SchoolListPage> {

  final DndService dndService = DndService();
  List<Map<String, dynamic>> schoolList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await dndService.getOrCreateDatabaseHandle();
    var data = await dndService.getSchoolList();
    schoolList = List<Map<String, dynamic>>.from(data);
    print(schoolList);
    setState(() { });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Spell Schools"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: schoolList.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                    child: ListTile(
                      onTap: () {
                        print("${schoolList[index]["name"]} clicked");
                      },
                      title: Text(schoolList[index]["name"]),
                      trailing: Text(
                        "${schoolList[index]["count"]}",
                        style: const TextStyle(
                          fontSize: 25
                        ),
                      ),
                    ),
                  );
              }
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateSchoolPage()
            )
          ).then((value) async {
            var data = await dndService.getSchoolList();
            schoolList = List<Map<String, dynamic>>.from(data);
            setState(() {});
          });
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

}
