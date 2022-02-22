import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

void main() => runApp(const MyApp(items: null,));

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.items}) : super(key: key);

  final List<Map>? items;


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
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late Model model;

  late List<Results> list = [];

  bool isSearching = false;

  String? filter = "";

  Future getDataFromApi() async {
    final url =
        await http.get(Uri.parse("https://randomuser.me/api/?results=5"));
    model = Model.fromJson(jsonDecode(url.body));
    setState(() {
      list = model.results!;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff161D30),
        centerTitle: true,
        title: !isSearching
            ? Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xff52fd9f),
                ),
              )
            : const TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Search a person"),
                    // onChanged: (teste) {
                    //   setState(() {
                    //       filter_Text = teste;
                    //   });
                    // },
              ),
        actions: [
          isSearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                    });
                  },
                  icon: const Icon(Icons.cancel))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  icon: const Icon(Icons.search))
        ],
      ),
      backgroundColor: const Color(0xff161D30),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          
          List<Map> filteredList = [];

          if(isSearching = false){
            for(dynamic name in list){
              String? nome = name['name'].toString().toLowerCase();
              if(nome.contains(isSearching.toString())){
                filteredList.add(name);
              }
              else{
                filteredList.addAll(name);
              }
            }
            }

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final k = list[i];
                return ListTile(
                  minVerticalPadding: 20,
                  leading: Hero(
                    tag: "imageProfile",
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          NetworkImage(k.picture!.thumbnail.toString()),
                    ),
                  ),
                  title: Text(
                    capitalize(k.name!.first.toString()) +
                        " " +
                        capitalize(k.name!.last.toString()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe2e2e2),
                    ),
                  ),
                  subtitle: RichText(
                      text: TextSpan(
                    style: const TextStyle(color: Color(0xffaaaaaa)),
                    children: <TextSpan>[
                      TextSpan(
                          text: k.gender! +
                              "  -  " +
                              k.dob!.age.toString() +
                              " years" +
                              '\n' +
                              k.cell!),
                      TextSpan(
                          text: '\n' + k.email!,
                          style: const TextStyle(color: Color(0xffde8e46))),
                      TextSpan(text: '\n' + list.length.toString())
                    ],
                  )),
                );
              },
            );
          }
      ),
    );
  }
}
