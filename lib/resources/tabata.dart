import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class Tabata {
  int sets;
  int reps;
  Duration exerciseTime;
  Duration restTime;
  Duration breakTime;
  Duration startDelay;

  Tabata({
    required this.sets,
    required this.reps,
    required this.startDelay,
    required this.exerciseTime,
    required this.restTime,
    required this.breakTime,
  });

  Duration getTotalTime() {
    return (exerciseTime * sets * reps) +
        (restTime * sets * (reps - 1)) +
        (breakTime * (sets - 1));
  }
}

Tabata get defaultTabata => Tabata(
  sets: 5,
  reps: 5,
  startDelay: const Duration(seconds: 10),
  exerciseTime: const Duration(seconds: 20),
  restTime: const Duration(seconds: 10),
  breakTime: const Duration(seconds: 60),
);

String formatTime(Duration duration) {
  String minutes = (duration.inMinutes).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

enum WorkoutState { initial, starting, exercising, resting, breaking, finished }

class Workout {
  final Tabata _config;

  /// Callback for when the workout's state has changed.
  final Function _onStateChange;

  WorkoutState _step = WorkoutState.initial;

  Timer? _timer;

  /// Time left in the current step
  late Duration _timeLeft;

  Duration _totalTime = const Duration(seconds: 0);

  /// Current set
  int _set = 0;

  /// Current rep
  int _rep = 0;

  /// Implement Audio Player
  final player = AudioPlayer();

  Workout(this._config, this._onStateChange);

  /// Starts or resumes the workout
  start() {
    if (_step == WorkoutState.initial) {
      _step = WorkoutState.starting;
      if (_config.startDelay.inSeconds == 0) {
        _nextStep();
      } else {
        _timeLeft = _config.startDelay;
      }
    }
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    _onStateChange();
  }

  /// Pauses the workout
  pause() {
    _timer?.cancel();
    _onStateChange();
  }

  /// Stops the timer without triggering the state change callback.
  dispose() {
    _timer?.cancel();
  }

  _tick(Timer timer) {
    if (_step != WorkoutState.starting) {
      _totalTime += const Duration(seconds: 1);
    }

    if (_timeLeft.inSeconds == 1) {
      _nextStep();
      player.play(AssetSource('sound/whistle.wav'));
    } else {
      _timeLeft -= const Duration(seconds: 1);
    }

    _onStateChange();
  }

  /// Moves the workout to the next step and sets up state for it.
  _nextStep() {
    if (_step == WorkoutState.exercising) {
      if (rep == _config.reps) {
        if (set == _config.sets) {
          _finish();
        } else {
          _startBreak();
        }
      } else {
        _startRest();
      }
    } else if (_step == WorkoutState.resting) {
      _startRep();
    } else if (_step == WorkoutState.starting ||
        _step == WorkoutState.breaking) {
      _startSet();
    }
  }

  _startRest() {
    _step = WorkoutState.resting;
    if (_config.restTime.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.restTime;
    player.play(AssetSource('sound/whistle.wav'));
  }

  _startRep() {
    _rep++;
    _step = WorkoutState.exercising;
    _timeLeft = _config.exerciseTime;
    player.play(AssetSource('sound/whistle.wav'));
  }

  _startBreak() {
    _step = WorkoutState.breaking;
    if (_config.breakTime.inSeconds == 0) {
      _nextStep();
      return;
    }
    _timeLeft = _config.breakTime;
    player.play(AssetSource('sound/whistle.wav'));
  }

  _startSet() {
    _set++;
    _rep = 1;
    _step = WorkoutState.exercising;
    _timeLeft = _config.exerciseTime;
    player.play(AssetSource('sound/whistle.wav'));
  }

  _finish() {
    _timer?.cancel();
    _step = WorkoutState.finished;
    _timeLeft = const Duration(seconds: 0);
    player.play(AssetSource('sound/whistle.wav'));
  }

  get config => _config;

  get set => _set;

  get rep => _rep;

  get step => _step;

  get timeLeft => _timeLeft;

  get totalTime => _totalTime;

  get isActive => _timer != null && _timer!.isActive;
}
