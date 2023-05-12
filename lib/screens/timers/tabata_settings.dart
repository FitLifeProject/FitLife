import 'package:fitlife/resources/tabata.dart';
import 'package:fitlife/screens/timers/tabata_workout.dart';
import 'package:fitlife/widgets/durationpicker.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


class TabataSettings extends StatefulWidget {
  const TabataSettings({Key? key}) : super(key: key);

  @override
  State<TabataSettings> createState() => _TabataSettingsState();
}

class _TabataSettingsState extends State<TabataSettings> {
  final Tabata _tabata = defaultTabata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Tabata Timer'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Sets'),
            subtitle: Text('${_tabata.sets}'),
            leading: const Icon(Icons.fitness_center),
            onTap: () {
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text('Sets in the workout'),
                      content: NumberPicker(
                        value: _tabata.sets,
                        minValue: 1,
                        maxValue: 10,
                        onChanged: (value) {
                          setState(() {
                            _tabata.sets = value;
                          });
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(_tabata.sets),
                          child: const Text('OK'),
                        )
                      ],
                    );
                  });
                },
              ).then((sets) {
                if (sets == null) return;
                setState(() {
                  _tabata.sets = sets;
                });
              });
            },
          ),
          ListTile(
            title: const Text('Reps'),
            subtitle: Text('${_tabata.reps}'),
            leading: const Icon(Icons.repeat),
            onTap: () {
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: const Text('Repetitions in each set'),
                      content: NumberPicker(
                        value: _tabata.reps,
                        minValue: 1,
                        maxValue: 10,
                        onChanged: (value) {
                          setState(() {
                            _tabata.reps = value;
                          });
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(_tabata.reps),
                          child: const Text('OK'),
                        )
                      ],
                    );
                  });
                },
              ).then((reps) {
                if (reps == null) return;
                setState(() {
                  _tabata.reps = reps;
                });
              });
            },
          ),
          const Divider(
            height: 10,
          ),
          ListTile(
            title: const Text('Starting Countdown'),
            subtitle: Text(formatTime(_tabata.startDelay)),
            leading: const Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.startDelay,
                    title: const Text('Countdown before starting workout'),
                  );
                },
              ).then((startDelay) {
                if (startDelay == null) return;
                setState(() {
                  _tabata.startDelay = startDelay;
                });
              });
            },
          ),
          ListTile(
            title: const Text('Exercise Time'),
            subtitle: Text(formatTime(_tabata.exerciseTime)),
            leading: const Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.exerciseTime,
                    title: const Text('Excercise time per repetition'),
                  );
                },
              ).then((exerciseTime) {
                if (exerciseTime == null) return;
                setState(() {
                  _tabata.exerciseTime = exerciseTime;
                });
              });
            },
          ),
          ListTile(
            title: const Text('Rest Time'),
            subtitle: Text(formatTime(_tabata.restTime)),
            leading: const Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.restTime,
                    title: const Text('Rest time between repetitions'),
                  );
                },
              ).then((restTime) {
                if (restTime == null) return;
                setState(() {
                  _tabata.restTime = restTime;
                });
              });
            },
          ),
          ListTile(
            title: const Text('Break Time'),
            subtitle: Text(formatTime(_tabata.breakTime)),
            leading: const Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.breakTime,
                    title: const Text('Break time between sets'),
                  );
                },
              ).then((breakTime) {
                if (breakTime == null) return;
                setState(() {
                  _tabata.breakTime = breakTime;
                });
              });
            },
          ),
          const Divider(height: 10),
          ListTile(
            title: const Text(
              'Total Time',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(formatTime(_tabata.getTotalTime())),
            leading: const Icon(Icons.timelapse),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabataWorkout(tabata: _tabata)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryTextTheme.button?.color,
        tooltip: 'Start Workout',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
