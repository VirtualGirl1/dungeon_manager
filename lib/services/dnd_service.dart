import 'dart:async';

import 'package:path/path.dart' as pathPackage;
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart' as sqflitePackage;

import 'network.dart';

const url = 'https://www.dnd5eapi.co/api/';

class DndService {

  late sqflitePackage.Database? db;
  late String path;

  Future<void> getOrCreateDatabaseHandle() async {
    try {
      print('SQFliteDbService getOrCreateDatabaseHandle TRY');
      var databasesPath = await sqflitePackage.getDatabasesPath();
      path = pathPackage.join(databasesPath, 'dnd.db');
      db = await sqflitePackage.openDatabase(
        path,
        onCreate: (sqflitePackage.Database db1, int version) async {
          await db1.execute(
            "CREATE TABLE SpellSchools(id INTEGER PRIMARY KEY, name TEXT, description TEXT);"
          );
          await db1.execute(
              "CREATE TABLE Spells(id INTEGER PRIMARY KEY, school TEXT, name TEXT, desc TEXT, higherLevel TEXT, range TEXT);"
          );
        },
        version: 1,
      );
      print('$db');
    } catch (e) {
      print('SQFliteDbService getOrCreateDatabaseHandle CATCH: $e');
    }
  }

  Future<dynamic> getSchoolList() async {
    List<Map<String, dynamic>> schoolList = [];

    // get data from remote api
    Uri url = Uri(
        scheme: 'https',
        host: 'www.dnd5eapi.co',
        path: '/api/magic-schools',
        query: ''
    );
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    data = data["results"];
    for (var item in data) {
      var school = await getSchoolDetails(item["index"]);
      schoolList.add(school);
    }

    // get local data
    try {
      var l = await db!.query('SpellSchools');
      schoolList = schoolList + l;
    }
    catch (e) {
      print('SQFliteDbService insertSpell CATCH: $e');
    }

    return schoolList;
  }

  Future<dynamic> getSchoolDetails(String school) async {
    Uri url = Uri(
        scheme: 'https',
        host: 'www.dnd5eapi.co',
        path: '/api/magic-schools/${school.toLowerCase()}',
        query: ''
    );
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    return data;
  }

  Future<dynamic> getBuiltIns() async {
    Uri url = Uri(
        scheme: 'https',
        host: 'www.dnd5eapi.co',
        path: '/api/magic-schools',
        query: ''
    );
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    List<String> names = [];

    for (var item in data["results"]) {
      names.add(item["name"]);
    }

    return names;
  }

  Future<int> getSchoolCount(String school) async {
    int count = 0;
    // try get remote count
    try {
      Uri url = Uri(
          scheme: 'https',
          host: 'www.dnd5eapi.co',
          path: '/api/spells',
          query: 'school=${school.toLowerCase()}'
      );
      NetworkService networkService = NetworkService(url);
      var data = await networkService.getData();
      int c = data["count"];
      count += c;
    }
    catch (e) {
      print(e);
    }

    // get spells in db
    try {
      var l = await db!.query(
          'Spells',
          where: "school = ?",
          whereArgs: [school]

      );
      count += l.length;
    }
    catch (e) {
      print(e);
    }

    return count;
  }

  Future<int> getSchoolCountInDb() async {
    try {
      var c = await db!.query('SpellSchools');
      return c.length;
    }
    catch (e) {
      return 0;
    }

  }

  Future<void> addSchool(Map<String, dynamic> school) async {
    try {
      await db!.insert(
          'SpellSchools',
          school,
          conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace
      );
    }
    catch (e) {
      print('SQFliteDbService addSchool CATCH: $e');
    }
  }

  Future<void> updateSchool(Map<String, dynamic> school) async {
    try {
      await db!.update(
          'SpellSchools',
          school,
          where: "id = ?",
        whereArgs: [school["id"]]
      );
    }
    catch (e) {
      print('SQFliteDbService addSchool CATCH: $e');
    }
  }

  Future<void> deleteSchool(Map<String, dynamic> school) async {
    try {
      await db!.delete(
        "SpellSchools",
        where: "id = ?",
        whereArgs: [school["id"]]
      );
    }
    catch (e) {
      print('SQFliteDbService deleteSchool CATCH: $e');
    }
  }

  Future<dynamic> getSpellsBySchool(String school) async {
    Uri url = Uri(
        scheme: 'https',
        host: 'www.dnd5eapi.co',
        path: '/api/spells',
        query: 'school=$school'
    );
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();

    List<Map<String, dynamic>> spells = [];
    for (var s in data["results"]) {
      var spell = await getSpellDetails(s["index"]);
      spells.add(spell);
    }

    // get spells in db
    try {
      var l = await db!.query(
        'Spells',
        where: "school = ?",
        whereArgs: [school]

      );
      spells = spells + l;
    }
    catch (e) {
      print(e);
    }

    return spells;
  }

  Future<dynamic> getSpellDetails(String index) async {
    Uri url = Uri(
        scheme: 'https',
        host: 'www.dnd5eapi.co',
        path: '/api/spells/$index',
        query: ''
    );
    NetworkService networkService = NetworkService(url);
    var data = await networkService.getData();
    return data;
  }

  Future<int> getSpellsInDb() async {
    try {
      var c = await db!.query('Spells');
      return c.length;
    }
    catch (e) {
      return 0;
    }
  }

  Future<void> addSpell(Map<String, dynamic> spell) async {
    try {
      await db!.insert(
          'Spells',
          spell,
          conflictAlgorithm: sqflitePackage.ConflictAlgorithm.replace
      );
    }
    catch (e) {
      print('SQFliteDbService addSpell CATCH: $e');
    }
  }
}