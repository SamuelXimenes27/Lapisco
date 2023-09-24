import 'package:desafio_lapisco/app/blocs/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppBloc bloc;
  final TextEditingController _searchController = TextEditingController();
  String query = "";

  @override
  void initState() {
    super.initState();
    bloc = AppBloc();
    bloc.getDataFromApi().then((value) {
      setState(() {
        bloc.list = bloc.model.results!;
      });
    });
  }

  void performSearch(String query) {
    setState(() {
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: const Color(0xff161D30),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff161D30),
      centerTitle: true,
      title: bloc.isSearching == false
          ? Text(
              widget.title,
              style: const TextStyle(
                color: Color(0xff52fd9f),
              ),
            )
          : TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintStyle: TextStyle(color: Colors.white),
                hintText: "Search a person",
              ),
              autofocus: true,
              controller: _searchController,
              onChanged: (query) {
                performSearch(query);
              },
            ),
      actions: [
        bloc.isSearching == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    bloc.isSearching = false;
                    _searchController.clear();
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
    );
  }

  Widget buildBody() {
    final filteredList = bloc.list.where((item) {
      final fullName =
          "${item.name!.first.toString()} ${item.name!.last.toString()}";
      return fullName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return FutureBuilder(
      future: bloc.getDataFromApi(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildSkeletonList();
        }

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, i) {
            final k = filteredList[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: const Color(0xff292f45),
              child: ListTile(
                minVerticalPadding: 10,
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(k.picture!.thumbnail.toString()),
                ),
                title: Text(
                  (k.name!.first.toString()) + " " + (k.name!.last.toString()),
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
                            k.cell!,
                      ),
                      TextSpan(
                        text: '\n' + k.email!,
                        style: const TextStyle(color: Color(0xffde8e46)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildSkeletonList() {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: 9,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xff292f45).withOpacity(0.8),
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: ListTile(
              minVerticalPadding: 10,
              leading: const Icon(
                Icons.ac_unit,
                size: 50,
              ),
              title: Text('Item number $index as title'),
              subtitle: const Text('Subtitle here'),
            ),
          );
        },
      ),
    );
  }
}
