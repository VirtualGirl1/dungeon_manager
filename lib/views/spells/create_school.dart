

import 'package:flutter/material.dart';

class CreateSchoolPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateSchoolState();

}

class CreateSchoolState extends State<CreateSchoolPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

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
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: "Name"
                  ),
                ),
                TextFormField(
                  controller: textEditingController2,
                  validator: (input) {
                    return input!.length > 2 ? null : "Must have a description";
                  },
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: "Description"
                  ),
                )
              ],
            ),
          )

        ),
      ),
    );
  }

}