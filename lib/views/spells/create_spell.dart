import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/dnd_service.dart';

class CreateSpellPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateSpellState();
}

class CreateSpellState extends State<CreateSpellPage> {

  final DndService dndService = DndService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();
  final TextEditingController textEditingController3 = TextEditingController();
  final TextEditingController textEditingController4 = TextEditingController();
  final TextEditingController textEditingController5 = TextEditingController();

  late String? name, desc, higherLevel, range;
  late int? rangeVal;
  List<String> rangeOptions = [ 'ranged', 'melee', 'self', 'shape'];
  late String rangeSelect = 'ranged';

  List<String> spellShapes = ['circle', 'cone', 'square'];
  String shape = 'circle';

  // for schools
  List<String> schoolList = ['Select School'];
  String school = 'Select School';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await dndService.getOrCreateDatabaseHandle();
    var data = await dndService.getSchoolList();
    var schools = List<Map<String, dynamic>>.from(data);
    for (var s in schools) {
      schoolList.add(s['name']);
    }

    school = schools.first['name'];

    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("New School"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: textEditingController1,
                  validator: (input) {
                    return input!.length > 2 ? null : "Must have a name";
                  },
                  onChanged: (String input) {
                    name = input;
                  },
                  onSaved: (input) {
                    name = input;
                  },
                  maxLength: 20,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name"
                  ),
                ),
                TextFormField(
                  controller: textEditingController2,
                  validator: (input) {
                    return input!.length > 2 ? null : "Must have a description";
                  },
                  onChanged: (String input) {
                    desc = input;
                  },
                  onSaved: (input) {
                    desc = input;
                  },
                  maxLength: 200,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description"
                  ),
                ),
                TextFormField(
                  controller: textEditingController3,
                  validator: (input) {
                    return input!.length > 2 ? null : "Must have upcasting description";
                  },
                  onChanged: (String input) {
                    higherLevel = input;
                  },
                  onSaved: (input) {
                    higherLevel = input;
                  },
                  maxLength: 200,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "UpCasting"
                  ),
                ),
                DropdownButton<String>(
                  value: rangeSelect,
                  items: rangeOptions.map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (value) {
                      rangeSelect = value!;
                      setState(() { });
                  }
                ),
                Visibility(
                  visible: rangeSelect == 'ranged',
                  child: TextFormField(
                    controller: textEditingController4,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "range"
                    ),
                    onChanged: (input) {
                      rangeVal = int.tryParse(input);
                    },
                    onSaved: (input) {
                      range = '${int.tryParse(input!)} $shape';
                    },
                  ),
                ),
                Visibility(
                  visible: rangeSelect == 'shape',
                    child: Column(
                      children: [
                        DropdownButton(
                          value: shape,
                          items: spellShapes.map((String val) {
                            return DropdownMenuItem(value: val, child: Text(val));
                          }).toList(),
                          onChanged: (String? value) {
                            shape = value!;
                            setState(() { });
                          },

                        ),
                        TextFormField(
                          controller: textEditingController5,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "range"
                          ),
                          onChanged: (input) {
                            rangeVal = int.tryParse(input);
                          },
                          onSaved: (input) {
                            range = '${int.tryParse(input!)} ft';
                          },

                        )
                      ],
                    )
                ),
                DropdownButton(
                  value: school,
                  items: schoolList.map((String val) {
                    return DropdownMenuItem(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (String? val) {
                    school = val!;
                  }
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (rangeSelect == 'self' || rangeSelect == 'melee') {
                          range = rangeSelect;
                        }
                        int count = await dndService.getSpellsInDb();
                        await dndService.addSpell(
                          {'id': count+1, 'name': name, 'desc': desc, 'higherLevel': higherLevel, 'school': school, 'range': range}
                        );

                        Navigator.pop(context);
                        setState(() { });
                      }
                      catch (e) {
                        print('HomeView addSpellSchool catch: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20)
                    ),
                    child: const Icon(Icons.check),
                  )
                )
              ],
            )
          )
        )
      ),
    );
  }
}