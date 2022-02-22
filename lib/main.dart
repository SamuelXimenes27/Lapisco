import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio Front-End - Lapisco',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Desafio Front-End - Lapisco'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Model model;

  late List<Results> list;

  Future getDataFromApi() async {
    final url = await http.get(Uri.parse("https://randomuser.me/api/"));
    model = Model.fromJson(jsonDecode(url.body));
    setState(() {
      list = model.results!;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff292f45),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Color(0xff52fd9f)),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      backgroundColor: const Color(0xff292f45),
      // ignore: unnecessary_null_comparison
      body: list == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(itemCount: list.length, itemBuilder: (context, i) {
              final k = list[i];
              return Column(
                children: [
                  //CircleAvatar(radius: 50,backgroundImage: NetworkImage(k.picture?.thumbnail),),
                  Text(k.name.first),
                ],
              );
            }),
    );
  }
}
