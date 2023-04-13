import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TimeR extends StatefulWidget {
  const TimeR({Key? key}) : super(key: key);

  @override
  State<TimeR> createState() => _TimeRState();
}

class _TimeRState extends State<TimeR> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool _isRunning = false;
  bool secondsAreZero = true;
  String ttlBtn1 = "Start";
  String ttlBtn2 = "Stop";
  late int _totalSecondsRemaining;
  late Timer _timer;
  late DateTime _startTime;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _totalSecondsRemaining =
        hours * 3600 + minutes * 60 + seconds;
  }

  void _startTimer() {
    _isRunning = true;
    player.play(AssetSource('sound/whistle.wav'));
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalSecondsRemaining--;
        if (_totalSecondsRemaining <= 0) {
          _stopTimer();
        } else {
          secondsAreZero = false;
        }
        if(!secondsAreZero) {
          ttlBtn1 = "Resume";
          ttlBtn2 = "Stop";
        }
      });
      _startTime = DateTime.now();
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
      _timer.cancel();
      if(!secondsAreZero) {
        ttlBtn2 = "Clear";
      } else {
        ttlBtn1 = "Start";
        ttlBtn2 = "Stop";
      }
    });
    player.play(AssetSource('sound/whistle.wav'));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: !_isRunning && secondsAreZero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          hours = int.parse(value);
                          _totalSecondsRemaining = hours * 3600 +
                              minutes * 60 +
                              seconds;
                        });
                      },
                    ),
                  ),
                  const Text("h"),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          minutes = int.parse(value);
                          _totalSecondsRemaining = hours * 3600 +
                              minutes * 60 +
                              seconds;
                        });
                      },
                    ),
                  ),
                  const Text("m"),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        setState(() {
                          seconds = int.parse(value);
                          _totalSecondsRemaining = hours * 3600 +
                              minutes * 60 +
                              seconds;
                        });
                      },
                    ),
                  ),
                  const Text("ss"),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            Text(
              '${(_totalSecondsRemaining ~/ 3600).toString().padLeft(2, '0')}:${((_totalSecondsRemaining % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_totalSecondsRemaining % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 60.0),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if(!_isRunning) {
                      _startTimer();
                    }
                  },
                  child: Text(ttlBtn1),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if(_isRunning) {
                      _stopTimer();
                    } else if(!_isRunning) {
                      setState(() {
                        _totalSecondsRemaining = 0;
                        secondsAreZero = true;
                      });
                    }
                  },
                  child: Text(ttlBtn2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
