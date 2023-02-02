import 'dart:convert';

import 'package:desafio_lapisco/app/blocs/app_bloc.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var bloc = AppBloc();

  @override
  void initState() {
    super.initState();
    bloc.getDataFromApi().then((value) => {
          setState(() {
            bloc.list = bloc.model.results!;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff161D30),
        centerTitle: true,
        title: bloc.isSearching == false
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
                  hintText: "Search a person",
                
                ),
              ),
        actions: [
          bloc.isSearching == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      bloc.isSearching = false;
                    });
                  },
                  icon: const Icon(Icons.cancel))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      bloc.isSearching = true;
                    });
                  },
                  icon: const Icon(Icons.search))
        ],
      ),
      backgroundColor: const Color(0xff161D30),
      body: FutureBuilder(builder: (BuildContext context, AsyncSnapshot) {
        List<Map> filteredList = [];

        // função para fazer a busca/filtro
        if (bloc.isSearching = false) {
          for (dynamic name in bloc.list) {
            String? nome = name['name'].toString().toLowerCase();
            if (nome.contains(bloc.isSearching.toString())) {
              filteredList.add(name);
            } else {
              filteredList.addAll(name);
            }
          }
        }

        return ListView.builder(
            itemCount: bloc.list.length,
            itemBuilder: (context, i) {
              final k = bloc.list[i]; //valores da API
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
