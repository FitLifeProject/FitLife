import 'package:fitlife/models/model.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:fitlife/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
          title: Text("Menu"),
          centerTitle: true,
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
        children: [],
      ),
      bottomNavigationBar: BottomNavigation(model, context),
    );
  }
}
