import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Chronometer extends StatefulWidget {
  const Chronometer({Key? key}) : super(key: key);

  @override
  State<Chronometer> createState() => _ChronometerState();
}

class _ChronometerState extends State<Chronometer> {
  int _secondsElapsed = 0;
  bool _isRunning = false;
  late Timer _timer;
  late DateTime _startTime;
  int _secondsBeforeStop = 0;
  bool secondsAreZero = true;
  String ttlBtn1 = "Start";
  String ttlBtn2 = "Stop";
  final _player = AudioPlayer();

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _isRunning = true;
    _secondsBeforeStop = _secondsElapsed;
    _player.play(AssetSource('sound/whistle.wav'));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if(_isRunning) {
          _secondsElapsed = DateTime.now().difference(_startTime).inSeconds + _secondsBeforeStop;
          secondsAreZero = false;
          if(!secondsAreZero) {
            ttlBtn1 = "Resume";
            ttlBtn2 = "Stop";
          }
        }
      });
    });
    _startTime = DateTime.now();
  }

  void _stopTimer() {
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
    _player.play(AssetSource('sound/whistle.wav'));
  }

  @override
  void dispose() {
    _timer.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clock: Chronometer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_secondsElapsed),
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        _secondsElapsed = 0;
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
