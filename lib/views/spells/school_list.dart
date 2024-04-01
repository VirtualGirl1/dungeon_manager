

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
  Map<String, int> schoolCounts = {};

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
    // get spell count for schools
    for (var item in schoolList) {
      schoolCounts[item["name"]] = await dndService.getSchoolCount(item["name"]);
    }
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
                var item = schoolList[index];
                return Card(
                    child: ListTile(
                      onTap: () {
                        print("${item["name"]} clicked");
                      },
                      title: Text(item["name"]),
                      trailing: Text(
                        "${schoolCounts[item["name"]]}",
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
