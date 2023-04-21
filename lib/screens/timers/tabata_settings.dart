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
  Tabata _tabata = defaultTabata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabata Timer'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Sets'),
            subtitle: Text('${_tabata.sets}'),
            leading: Icon(Icons.fitness_center),
            onTap: () {
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Sets in the workout'),
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
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(_tabata.sets),
                          child: Text('OK'),
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
            title: Text('Reps'),
            subtitle: Text('${_tabata.reps}'),
            leading: Icon(Icons.repeat),
            onTap: () {
              showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Repetitions in each set'),
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
                          child: Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(_tabata.reps),
                          child: Text('OK'),
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
          Divider(
            height: 10,
          ),
          ListTile(
            title: Text('Starting Countdown'),
            subtitle: Text(formatTime(_tabata.startDelay)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.startDelay,
                    title: Text('Countdown before starting workout'),
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
            title: Text('Exercise Time'),
            subtitle: Text(formatTime(_tabata.exerciseTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.exerciseTime,
                    title: Text('Excercise time per repetition'),
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
            title: Text('Rest Time'),
            subtitle: Text(formatTime(_tabata.restTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.restTime,
                    title: Text('Rest time between repetitions'),
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
            title: Text('Break Time'),
            subtitle: Text(formatTime(_tabata.breakTime)),
            leading: Icon(Icons.timer),
            onTap: () {
              showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  return DurationPickerDialog(
                    initialDuration: _tabata.breakTime,
                    title: Text('Break time between sets'),
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
          Divider(height: 10),
          ListTile(
            title: Text(
              'Total Time',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(formatTime(_tabata.getTotalTime())),
            leading: Icon(Icons.timelapse),
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
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
