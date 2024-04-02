import 'package:flutter/material.dart';

class SchoolDetailsPage extends StatefulWidget {
  const SchoolDetailsPage({super.key, required this.school});

  final Map<String, dynamic> school;

  @override
  State<StatefulWidget> createState() => SchoolDetailsState();
}

class SchoolDetailsState extends State<SchoolDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("${widget.school["name"]} Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: const Color(0x88888888),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.school["name"],
                  style: const TextStyle(
                      fontSize: 30
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "${widget.school["desc"]}",
                  style: const TextStyle(
                      fontSize: 20
                  ),
                )
              ],
            ),
          )

        ),
      )
    );
  }
}
