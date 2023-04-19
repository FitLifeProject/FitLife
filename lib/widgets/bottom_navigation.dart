import 'package:fitlife/screens/exercise_posts.dart';
import 'package:fitlife/screens/home.dart';
import 'package:fitlife/screens/menu.dart';
import 'package:fitlife/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget BottomNavigation(model, context) {
  return BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
    elevation: 0,
    currentIndex: model.selectedScreen,
    type: BottomNavigationBarType.fixed,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: IconButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
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
          icon: IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            icon: const FaIcon(FontAwesomeIcons.squarePlus, color: Colors.lightGreenAccent),
            onPressed: () async {
              var navigator = Navigator.of(context);
              await model.obtainValuesForPublishingPostToTheUser();
              navigator.push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ExercisePosts();
                  },
                ),
              );
            },
          ),
        label: "Posts",
      ),
      BottomNavigationBarItem(
        icon: IconButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
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
        icon: IconButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
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
