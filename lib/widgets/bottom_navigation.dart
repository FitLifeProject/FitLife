import 'package:fitlife/screens/home.dart';
import 'package:fitlife/screens/menu.dart';
import 'package:fitlife/screens/profile.dart';
import 'package:flutter/material.dart';

Widget BottomNavigation(model, context) {
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
    elevation: 0,
    currentIndex: model.selectedScreen,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          label: Text("Home", style: TextStyle(color: (model.selectedScreen == 0) ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark)),
          icon: Icon(Icons.home, color: (model.selectedScreen == 0) ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark),
          onPressed: () {
            model.changeScreen(0);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Home();
                },
              ),
            );
          },
        ),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          label: Text("Profile", style: TextStyle(color: (model.selectedScreen == 1) ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark)),
          icon: Icon(Icons.account_circle, color: (model.selectedScreen == 1) ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark),
          onPressed: () {
            model.changeScreen(1);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Profile();
                },
              ),
            );
          },
        ),
        label: "Profile",
      ),
      BottomNavigationBarItem(
        icon: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          label: Text("Menu", style: TextStyle(color: (model.selectedScreen == 2) ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark)),
          icon: Icon(Icons.menu, color: (model.selectedScreen == 2) ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark),
          onPressed: () {
            model.changeScreen(2);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const Menu();
                },
              ),
            );
          },
        ),
        label: "Menu",
      ),
    ],
  );
}
