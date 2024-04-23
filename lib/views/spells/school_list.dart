

import 'package:dungeon_manager/services/dnd_service.dart';
import 'package:dungeon_manager/views/spells/create_school.dart';
import 'package:dungeon_manager/views/spells/create_spell.dart';
import 'package:dungeon_manager/views/spells/school_details.dart';
import 'package:dungeon_manager/views/spells/spell_list.dart';
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
  List<String> builtIns = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await dndService.getOrCreateDatabaseHandle();
    var data = await dndService.getSchoolList();
    schoolList = List<Map<String, dynamic>>.from(data);
    print(schoolList);
    // get spell count for schools
    for (var item in schoolList) {
      schoolCounts[item["name"]] = await dndService.getSchoolCount(item["name"]);
    }
    getCounts();
    setState(() { });
  }

  Future<void> getCounts() async {
    builtIns = await dndService.getBuiltIns();
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
                      onTap: () async {
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (BuildContext builder) => SpellListPage(schoolName: item["name"])
                            )
                        );
                        print("${item["name"]} clicked");
                      },
                      onLongPress: () {
                        schoolContextAction(item);
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
              builder: (context) => const CreateOrEditSchoolPage()
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

  Future<void> schoolContextAction(Map<String, dynamic> school, {bool delete = false}) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {


          if (!delete) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext builder) => SchoolDetailsPage(school: school)
                          )
                      );
                    },
                    child: const Text("View Details"),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext builder) => CreateSpellPage()
                        )
                      );
                    },
                    child: const Text("Add Spell"),
                  ),
                  Visibility(
                    visible: !builtIns.contains(school["name"]),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        schoolContextAction(school, delete: true);
                      },
                      child: const Text("Delete School"),
                    ),
                  ),
                  Visibility(
                    visible: !builtIns.contains(school["name"]),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext builder) => CreateOrEditSchoolPage(edit: true, school: school,)
                            )
                        ).then((value) async {
                          var data = await dndService.getSchoolList();
                          schoolList = List<Map<String, dynamic>>.from(data);
                          setState(() {});
                        });
                      },
                      child: const Text("Edit School"),
                    ),
                  ),
                ],
              ),
            );
          }
          else {
            return AlertDialog(
              title: Text("Delete ${school["name"]}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Deleting this item will also delete all spells under it"),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await dndService.deleteSchool(school);
                          var data = await dndService.getSchoolList();
                          schoolList = List<Map<String, dynamic>>.from(data);
                          setState(() { });
                        },
                        child: const Text("Delete")
                      )
                    ],
                  )
                ],
              ),
            );
          }
        }
    );
  }


}
