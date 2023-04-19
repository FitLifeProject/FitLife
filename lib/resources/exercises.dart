enum ExercisesType {
  gymnastics("Gymnastics"),
  strength("Strength"),
  strengthening("Strengthening"),
  none("none");

  final String name;

  const ExercisesType(this.name);
}

enum Exercises {
  burpees(ExercisesType.gymnastics, "Burpees", "https://youtu.be/hAeyJGLnrxQ"),
  push_up(ExercisesType.gymnastics, "Push up", "https://youtu.be/M1IfJmVjKW0"),
  squads(ExercisesType.gymnastics, "Squads", "https://youtu.be/xDdSZmWNYQI"),
  pull_up(ExercisesType.gymnastics, "Pulls Up", "https://youtu.be/ifOBltCCRZw"),
  plank(ExercisesType.gymnastics, "Plank", "https://youtu.be/CO7MktWaoD8"),
  bench_press(ExercisesType.strength, "Bench Press", "https://youtu.be/FgVDxCxXkmc"),
  wall_ball(ExercisesType.strength, "Wall Ball", "https://youtu.be/UUo2ONp4iGc"),
  front_squad(ExercisesType.strength, "Front Squad", "https://youtu.be/UoikaYjLRNk"),
  swing(ExercisesType.strength, "Bell Swing", "https://youtu.be/0dvov7IHvL0"),
  deadlift(ExercisesType.strength, "Deadlift", "https://youtu.be/qCGtwPhfGf4"),
  run(ExercisesType.strengthening, "Run", "https://youtu.be/gF0rrpMH-Jo"),
  stairs(ExercisesType.strengthening, "Stairs", "https://youtu.be/cjjiSpM8OEs"),
  sprint(ExercisesType.strengthening, "Sprint", "https://youtu.be/QOnX8cVbbdE"),
  single_unders(ExercisesType.strengthening, "Single Under", "https://youtu.be/ZV10GlZk4To"),
  jump_squat(ExercisesType.strengthening, "Jump Squat", "https://youtu.be/J6Y520KkwOA"),
  none(ExercisesType.none, "", "");

  final ExercisesType type;
  final String name;
  final String url;

  const Exercises(this.type, this.name, this.url);
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