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
  startDelay: Duration(seconds: 10),
  exerciseTime: Duration(seconds: 20),
  restTime: Duration(seconds: 10),
  breakTime: Duration(seconds: 60),
);

String formatTime(Duration duration) {
  String minutes = (duration.inMinutes).toString().padLeft(2, '0');
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
