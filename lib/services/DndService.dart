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
            "CREATE TABLE SpellSchools(id INTEGER PRIMARY KEY, name TEXT, description TEXT)",
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
      item["count"] = await getSchoolCount(item["name"]);
    }

    // get local data
    List<Map<String, dynamic>> schoolList;
    try {
      schoolList = await db!.query('SpellSchools');
      data = data + schoolList;

    }
    catch (e) {
      print('SQFliteDbService insertDog CATCH: $e');
    }

    return data;
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
      print('SQFliteDbService insertDog CATCH: $e');
    }
  }

}