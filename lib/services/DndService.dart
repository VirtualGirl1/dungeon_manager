import 'dart:async';

import 'package:http/http.dart';

import 'network.dart';

const url = 'https://www.dnd5eapi.co/api/';

class DndService {

  Future<dynamic> getSchoolList() async {
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

}