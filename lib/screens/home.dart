import 'package:fitlife/models/model.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:fitlife/screens/gyminfo.dart';
import 'package:fitlife/screens/gymresults.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _searchTextController = TextEditingController();
  List<String> gyms = [];

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
        leading: IconButton(
          icon: Image.asset("assets/img/fitlife.png"),
          onPressed: () {
          },
        ),
        title: TextField(
          controller: _searchTextController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                gyms = model.gNames.where((element) => element.contains(_searchTextController.text)).toList();
                if(gyms.length == 1) {
                  model.getGymInfo(gyms[0]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GymInfo();
                      },
                    ),
                  );
                } else if(gyms.length > 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GymResults(gyms: gyms);
                      }
                    )
                  );
                } else if(gyms.length <= 0) {
                  model.showSnackbar(context, "Gym not found");
                }
              },
            ),
            hintText: '',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2, color: Theme.of(context).colorScheme.inverseSurface
              )
            ),
            enabledBorder: InputBorder.none,
          ),
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              if (model.userInfo[3] != "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Chat();
                    },
                  ),
                );
              } else {
                model.showSnackbar(context, "You must join to a Gym");
              }
            },
          ),
        ]
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
}
