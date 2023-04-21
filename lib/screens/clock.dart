import 'package:fitlife/screens/timers/chronometer.dart';
import 'package:fitlife/screens/timers/tabata_settings.dart';
import 'package:fitlife/screens/timers/timer.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  bool _showInformation = false;
  int _infoIndex = 0;
  final List _informationTitle = ["Tabata", "Chronometer", "Timer"];
  final List _information = ["A form of high-intensity physical training in which very short periods of extremely demanding activity are alternated with shorter periods of rest, typically over a period of four minutes.", "A timepiece or timing device with a special mechanism for ensuring and adjusting its accuracy, for use in determining longitude at sea or for any purpose where very exact measurement of time is required.", "A timer is a device that measures time, especially one that is part of a machine and causes it to start or stop working at specific times."];

  Widget informationFloatingActionButton(int index) {
    return FloatingActionButton(
        heroTag: "Information$index",
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          setState(() {
            _showInformation = !_showInformation;
            if(index > -1) {
              _infoIndex = index;
            }
          });
        },
        child: Icon(Icons.info_outline, color: Theme.of(context).primaryColorLight)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
          title: const Text("Clock"),
          centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const TabataSettings();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(_informationTitle[0]),
              ),
              const SizedBox(width: 5,),
              informationFloatingActionButton(0)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Chronometer();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Chronometer"),
              ),
              const SizedBox(width: 5,),
              informationFloatingActionButton(1)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const TimeR();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Timer"),
              ),
              const SizedBox(width: 5,),
              informationFloatingActionButton(2)
            ],
          ),
          Visibility(
            visible: _showInformation,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showInformation = false;
                });
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Title(color: Theme.of(context).primaryColorLight, child: Text(_informationTitle[_infoIndex], style: const TextStyle(fontSize: 20))),
                      Text(_information[_infoIndex], style: const TextStyle(fontSize: 16),)
                    ],
                  ),
                )
              ),
            )
          ),
        ],
      ),
    );
  }
}
