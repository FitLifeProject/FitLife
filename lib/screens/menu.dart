import 'dart:io';
import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/clock_information.dart';
import 'package:fitlife/screens/profile_settings.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:fitlife/screens/timers/chronometer.dart';
import 'package:fitlife/screens/timers/tabata_settings.dart';
import 'package:fitlife/screens/timers/timer.dart';
import 'package:fitlife/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _showInformation = false;
  int _infoIndex = 0;

  clockInformationButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showInformation = !_showInformation;
          if(index > -1) {
            _infoIndex = index;
          }
        });
        showDialog(
          context: context,
          builder: (context) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: AlertDialog(
              title: Title(color: Theme.of(context).primaryColorLight, child: Text(clockInformationTitle[_infoIndex], style: const TextStyle(fontSize: 20))),
              content: Text(clockInformation[_infoIndex], style: const TextStyle(fontSize: 16)),
            ),
          ),
        );
      },
      child: Icon(Icons.info_outline, color: Theme.of(context).primaryColorLight),
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return WillPopScope(
      onWillPop: () async {
        bool result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure you want to exit from Fitlife?"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                child: const Text("Yes"),
                onPressed: () {
                  model.signOut;
                  if (Platform.isIOS) {
                    exit(0);
                  } else if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  }
                },
              ),
            ],
          ),
        );
        return result;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
            leading: IconButton(
              icon: Image.asset("assets/img/fitlife.png"),
              onPressed: () {
              },
            ),
            title: const Text("Menu"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.chat),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const TabataSettings();
                    },
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.watch_later_outlined),
                title: Text(clockInformationTitle[0]),
                trailing: clockInformationButton(0)
              )
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Chronometer();
                      },
                    ),
                  );
                },
                child: ListTile(
                    leading: const Icon(Icons.watch_later_outlined),
                    title: Text(clockInformationTitle[1]),
                    trailing: clockInformationButton(1)
                )
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const TimeR();
                      },
                    ),
                  );
                },
                child: ListTile(
                    leading: const Icon(Icons.watch_later_outlined),
                    title: Text(clockInformationTitle[2]),
                    trailing: clockInformationButton(2)
                )
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfileSettings();
                    },
                  ),
                );
              },
              child: const ListTile(
                  leading: Icon(Icons.person_outlined),
                  title: Text("Profile Settings"),
                  trailing: Icon(Icons.arrow_forward)
              ),
            ),
            GestureDetector(
              onTap: () async {
                await model.signOut(context);
              },
              child: const ListTile(
                  leading: Icon(Icons.person_outlined),
                  title: Text("Logout"),
                  trailing: Icon(Icons.logout_outlined)
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigation(model, context),
      ),
    );
  }
}
