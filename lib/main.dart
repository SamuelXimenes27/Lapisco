import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

void main() => runApp(const MyApp(
      items: null,
    ));

// função para dar upper na primeira letra
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.items}) : super(key: key);

  final List<Map>? items;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Desafio Front-End - Lapisco',
      home: MyHomePage(title: 'Desafio Front-End - Lapisco'),
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

  Future getDataFromApi() async {
    //dependendo do valor do "results" pode nao gerar nada ate que de refresh algumas vezes 
    final url = await http.get(Uri.parse("https://randomuser.me/api/?results=26")); //results controla o numero de cards que será gerado
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
      body: FutureBuilder(builder: (BuildContext context, AsyncSnapshot) {
        List<Map> filteredList = [];

        // função para fazer a busca/filtro
        if (isSearching = false) {
          for (dynamic name in list) {
            String? nome = name['name'].toString().toLowerCase();
            if (nome.contains(isSearching.toString())) {
              filteredList.add(name);
            } else {
              filteredList.addAll(name);
            }
          }
        }

        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final k = list[i]; //valores da API
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                color: const Color(0xff292f45),
                child: ListTile(
                  minVerticalPadding: 10,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(k.picture!.thumbnail.toString()),
                  ),
                  title: Text(
                    (k.name!.first.toString()) +
                        " " +
                        (k.name!.last.toString()),
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
                          text: k.gender!.capitalize() +
                              " - " +
                              k.dob!.age.toString() +
                              " years" +
                              '\n' +
                              k.cell!),
                      TextSpan(
                          text: '\n' + k.email!,
                          style: const TextStyle(color: Color(0xffde8e46))),
                    ],
                  )),
                ),
              );
            });
      }),
    );
  }
}
