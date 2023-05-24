// ignore_for_file: constant_identifier_names

enum ExercisesType {
  gymnastics("Gymnastics"),
  strength("Strength"),
  strengthening("Strengthening"),
  none("none");

  final String name;

  const ExercisesType(this.name);
}

enum MeasuresType {
  reps("sets_reps"),
  meters("sets_reps_meters"),
  seconds("sets_reps_seconds"),
  lbs("sets_reps_lbs"),
  none("");
  final String type;

  const MeasuresType(this.type);
}

enum Exercises {
  burpees(ExercisesType.gymnastics, "Burpees", "https://youtu.be/hAeyJGLnrxQ", MeasuresType.reps),
  push_up(ExercisesType.gymnastics, "Push up", "https://youtu.be/M1IfJmVjKW0", MeasuresType.reps),
  squads(ExercisesType.gymnastics, "Squads", "https://youtu.be/xDdSZmWNYQI", MeasuresType.reps),
  pull_up(ExercisesType.gymnastics, "Pulls Up", "https://youtu.be/ifOBltCCRZw", MeasuresType.reps),
  plank(ExercisesType.gymnastics, "Plank", "https://youtu.be/CO7MktWaoD8", MeasuresType.seconds),
  bench_press(ExercisesType.strength, "Bench Press", "https://youtu.be/FgVDxCxXkmc", MeasuresType.lbs),
  wall_ball(ExercisesType.strength, "Wall Ball", "https://youtu.be/UUo2ONp4iGc", MeasuresType.lbs),
  front_squad(ExercisesType.strength, "Front Squad", "https://youtu.be/UoikaYjLRNk", MeasuresType.lbs),
  swing(ExercisesType.strength, "Bell Swing", "https://youtu.be/0dvov7IHvL0", MeasuresType.lbs),
  deadlift(ExercisesType.strength, "Deadlift", "https://youtu.be/qCGtwPhfGf4", MeasuresType.lbs),
  run(ExercisesType.strengthening, "Run", "https://youtu.be/gF0rrpMH-Jo", MeasuresType.meters),
  stairs(ExercisesType.strengthening, "Stairs", "https://youtu.be/cjjiSpM8OEs", MeasuresType.meters),
  sprint(ExercisesType.strengthening, "Sprint", "https://youtu.be/QOnX8cVbbdE", MeasuresType.meters),
  single_unders(ExercisesType.strengthening, "Single Under", "https://youtu.be/ZV10GlZk4To", MeasuresType.reps),
  jump_squat(ExercisesType.strengthening, "Jump Squat", "https://youtu.be/J6Y520KkwOA", MeasuresType.reps),
  none(ExercisesType.none, "", "", MeasuresType.none);

  final ExercisesType type;
  final String name;
  final String url;
  final MeasuresType measuresType;

  const Exercises(this.type, this.name, this.url, this.measuresType);
}

Map<String, Exercises> strToExercise = {
  "Burpees" : Exercises.burpees,
  "Push up" : Exercises.push_up,
  "Squads" : Exercises.squads,
  "Pulls Up" : Exercises.pull_up,
  "Plank" : Exercises.plank,
  "Bench Press" : Exercises.bench_press,
  "Wall Ball" : Exercises.wall_ball,
  "Front Squad": Exercises.front_squad,
  "Bell Swing" : Exercises.swing,
  "Deadlift": Exercises.deadlift,
  "Run": Exercises.run,
  "Stairs": Exercises.stairs,
  "Sprint": Exercises.sprint,
  "Single Under": Exercises.single_unders,
  "Jump Squat": Exercises.jump_squat,
};