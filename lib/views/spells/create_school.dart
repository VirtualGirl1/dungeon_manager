

import 'package:flutter/material.dart';

import '../../services/dnd_service.dart';

class CreateOrEditSchoolPage extends StatefulWidget {
  const CreateOrEditSchoolPage({super.key, this.edit = false, this.school});

  final bool edit;
  final Map<String, dynamic>? school;

  @override
  State<StatefulWidget> createState() => CreateOrEditSchoolState();

}

class CreateOrEditSchoolState extends State<CreateOrEditSchoolPage> {

  final DndService dndService = DndService();
  final formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

  late String? name, description;


  @override
  void initState() {
    super.initState();
    initDbHandle();

    if (widget.edit) {
      name = widget.school!["name"];
      description = widget.school!["description"];
      textEditingController1.text = widget.school!["name"];
      textEditingController2.text = widget.school!["description"];
    }
  }

  initDbHandle() async {
    await dndService.getOrCreateDatabaseHandle();
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
                  onChanged: (input) {
                    description = input;
                  },
                  onSaved: (input) {
                    description = input;
                  },
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Description"
                  ),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {

                      try {
                        int count = await dndService.getSchoolCountInDb();
                        if (name!.isNotEmpty && description!.isNotEmpty) {
                            if (widget.edit) {
                              await dndService.updateSchool(
                                  { 'id': widget.school!["id"], "name": name, "description": description }
                              );
                            }
                            else {
                              await dndService.addSchool(
                                  { 'id': count+1, "name": name, "description": description }
                              );
                            }
                        }
                        Navigator.pop(context);
                        setState(() {});
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
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 40)
                )
              ],
            ),
          )

        ),
      ),
    );
  }

}