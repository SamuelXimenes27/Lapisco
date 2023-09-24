import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model.dart';

class AppBloc {
  late Model model;

  late List<Results> list = [];

  bool isSearching = false;

  Future getDataFromApi() async {
    final url =
        await http.get(Uri.parse("https://randomuser.me/api/?results=26"));
    model = Model.fromJson(jsonDecode(url.body));
    return model.results;
  }
}
