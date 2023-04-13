import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class TabataTimer extends StatefulWidget {
  const TabataTimer({Key? key}) : super(key: key);

  @override
  State<TabataTimer> createState() => _TabataTimerState();
}

class _TabataTimerState extends State<TabataTimer> {
  int seconds = 20;
  int restSeconds = 10;
  late int _secondsLeft;
  int _lapsLeft = 8;
  late int laps;
  bool _isWorking = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = seconds;
  }

  void _startTimer() {
    laps = _lapsLeft;
    final player = AudioPlayer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          if (_lapsLeft > 0) {
            _isWorking = !_isWorking;
            if (_isWorking) {
              player.play(AssetSource('sound/whistle.wav'));
              _secondsLeft = seconds;
            } else {
              player.play(AssetSource('sound/whistle.wav'));
              _secondsLeft = restSeconds;
              _lapsLeft--;
            }
          } else {
            _stopTimer();
            _isWorking = true;
            _secondsLeft = seconds;
            _lapsLeft = laps;
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isWorking ? Colors.green : Colors.red,
      appBar: AppBar(
        title: const Text('Clock: Tabata'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isWorking ? 'Work' : 'Break',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            Text(
              '$_secondsLeft',
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 20),
            Text(
              '$_lapsLeft laps left',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: const Text('Stop'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _lapsLeft = laps;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "Increment seconds",
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      if(seconds < 61) {
                        seconds += 10;
                        restSeconds += 5;
                        _secondsLeft = seconds;
                      }
                    });
                  },
                  child: const Text("+10"),
                ),
                FloatingActionButton(
                  heroTag: "Decrement seconds",
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      if(seconds > 20 && restSeconds > 10) {
                        seconds -= 10;
                        restSeconds -= 5;
                        _secondsLeft = seconds;
                      }
                    });
                  },
                  child: const Text("-10"),
                ),
                FloatingActionButton(
                    heroTag: "Increment Laps",
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _lapsLeft++;
                      });
                      laps = _lapsLeft;
                    },
                    child: Icon(Icons.plus_one, color: Theme.of(context).primaryColorLight)
                ),
                FloatingActionButton(
                    heroTag: "Decrement Laps",
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        if(_lapsLeft > 1) {
                          _lapsLeft--;
                        }
                        laps = _lapsLeft;
                      });
                    },
                    child: Icon(Icons.exposure_minus_1, color: Theme.of(context).primaryColorLight)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
