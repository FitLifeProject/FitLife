import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youtube/youtube_thumbnail.dart';

class AddBenchmark extends StatefulWidget {
  const AddBenchmark({Key? key}) : super(key: key);

  @override
  State<AddBenchmark> createState() => _AddBenchmarkState();
}

class _AddBenchmarkState extends State<AddBenchmark> {
  final allTypes = Exercises.values;

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    List<TextEditingController> oldSetsControllers = [];
    List<TextEditingController> oldRepsControllers = [];
    List<TextEditingController> oldValuesControllers = [];
    List<TextEditingController> setsControllers = [];
    List<TextEditingController> repsControllers = [];
    List<TextEditingController> valuesControllers = [];
    for (int i = 0; i < model.postsExercises.length; i++) {
      oldSetsControllers.add(TextEditingController());
      oldRepsControllers.add(TextEditingController());
      oldValuesControllers.add(TextEditingController());
      setsControllers.add(TextEditingController());
      repsControllers.add(TextEditingController());
      valuesControllers.add(TextEditingController());
    }
    String exercises = "";
    List oldSets = [];
    List oldReps = [];
    List oldValues = [];
    List sets = [];
    List reps = [];
    List values = [];
    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Are you sure you don't want post the exercise you have done?"),
              content: const Text("Important: If you exit everything will be discarded!"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    model.setAddingPostExerciseScreen(0);
                    model.addRemExercise("", clear: true);
                    reps = [];
                    sets = [];
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ));
        return result ?? false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Add benchmark"),
          centerTitle: true,
          actions: [
            Visibility(
              visible: model.addingPostExerciseScreen == 1,
              child: IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  if (model.addingPostExerciseScreen == 1 && model.postsExercises.isNotEmpty) {
                    model.setAddingPostExerciseScreen(0);
                  }
                },
              ),
            ),
            Visibility(
                visible: model.addingPostExerciseScreen == 0 && model.postsExercises.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    exercises = model.postsExercises.join(",");
                    oldReps = [];
                    oldSets = [];
                    reps = [];
                    sets = [];
                    for (int i = 0; i < model.postsExercises.length; i++) {
                      if(oldRepsControllers[i].text.isNotEmpty) {
                        oldReps.add(oldRepsControllers[i].text);
                      }
                      if(oldSetsControllers[i].text.isNotEmpty) {
                        oldSets.add(oldSetsControllers[i].text);
                      }
                      if(strToExercise[model.postsExercises[i]]?.measuresType != MeasuresType.reps) {
                        if(oldValuesControllers[i].text.isNotEmpty) {
                          oldValues.add(oldValuesControllers[i].text);
                          model.switchErrorBenchmarkPosts(false);
                        } else {
                          model.switchErrorBenchmarkPosts(true);
                        }
                      } else {
                        oldValues.add("_");
                      }
                      if(repsControllers[i].text.isNotEmpty) {
                        reps.add(repsControllers[i].text);
                      }
                      if(setsControllers[i].text.isNotEmpty) {
                        sets.add(setsControllers[i].text);
                      }
                      if(strToExercise[model.postsExercises[i]]?.measuresType != MeasuresType.reps) {
                        if(valuesControllers[i].text.isNotEmpty) {
                          values.add(valuesControllers[i].text);
                          model.switchErrorBenchmarkPosts(false);
                        } else {
                          model.switchErrorBenchmarkPosts(true);
                        }
                      } else {
                        values.add("_");
                      }
                    }
                    if(model.errorBenchmarkPosts) {
                      model.showSnackbar(context, "You must fill every field.");
                    } else {
                      if(exercises.isNotEmpty && reps.isNotEmpty && sets.isNotEmpty && oldReps.isNotEmpty && oldSets.isNotEmpty) {
                        model.sendMyBenchmarks(exercises, reps.join(","), sets.join(","), values.join(","), oldReps.join(","), oldSets.join(","), oldValues.join(","));
                        model.addRemExercise("", clear: true);
                        sets = [];
                        reps = [];
                        values = [];
                        oldSets = [];
                        oldReps = [];
                        oldValues = [];
                        model.setAddingPostExerciseScreen(0);
                        Navigator.pop(context);
                      } else {
                        if(exercises.isEmpty) {
                          model.showSnackbar(context, "You must choose at least 1 exercise.");
                        } else if(reps.isEmpty || sets.isEmpty || oldReps.isEmpty || oldSets.isEmpty) {
                          model.showSnackbar(context, "You must fill every field.");
                        }
                      }
                    }
                  },
                )
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if(model.addingPostExerciseScreen == 0) ...[
                Visibility(
                    visible: model.postsExercises.isNotEmpty,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.postsExercises.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Text(model.postsExercises[index]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Prev sets: "),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      controller: oldSetsControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Prev reps: "),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      controller: oldRepsControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if(strToExercise[model.postsExercises[index]]?.measuresType == MeasuresType.lbs)...[
                                    const Text("Prev lbs:"),
                                  ] else if(strToExercise[model.postsExercises[index]]?.measuresType == MeasuresType.meters)...[
                                    const Text("Prev meters:"),
                                  ] else if(strToExercise[model.postsExercises[index]]?.measuresType == MeasuresType.seconds)...[
                                    const Text("Prev seconds:"),
                                  ],
                                  const SizedBox(width: 2),
                                  Visibility(
                                    visible: strToExercise[model.postsExercises[index]]?.measuresType != MeasuresType.reps,
                                    child: SizedBox(
                                      width: 50,
                                      child: TextField(
                                        controller: oldValuesControllers[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.inversePrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Sets: "),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      controller: setsControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Text("Reps: "),
                                  const SizedBox(width: 2),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      controller: repsControllers[index],
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.inversePrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if(strToExercise[model.postsExercises[index]]?.measuresType == MeasuresType.lbs)...[
                                    const Text("lbs:"),
                                  ] else if(strToExercise[model.postsExercises[index]]?.measuresType == MeasuresType.meters)...[
                                    const Text("Meters:"),
                                  ] else if(strToExercise[model.postsExercises[index]]?.measuresType == MeasuresType.seconds)...[
                                    const Text("Seconds:"),
                                  ],
                                  const SizedBox(width: 2),
                                  Visibility(
                                    visible: strToExercise[model.postsExercises[index]]?.measuresType != MeasuresType.reps,
                                    child: SizedBox(
                                      width: 50,
                                      child: TextField(
                                        controller: valuesControllers[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.inversePrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                    )
                ),
                GestureDetector(
                  onTap: () {
                    model.setAddingPostExerciseScreen(1);
                  },
                  child: const ListTile(
                    leading: FaIcon(FontAwesomeIcons.dumbbell),
                    title: Text("Add / Remove Exercise"),
                    trailing: Icon(Icons.arrow_forward_outlined),
                  ),
                ),
              ] else if (model.addingPostExerciseScreen == 1) ...[
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 4
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allTypes.length,
                  itemBuilder: (context, index) {
                    final type = allTypes[index];
                    if (type.type == ExercisesType.none || type.name.isEmpty || type.url.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        model.addRemExercise(type.name);
                      },
                      child: Column(
                        children: [
                          Text(type.name),
                          Image.network(YoutubeThumbnail(youtubeId: type.url.replaceRange(0, 17, "")).hq(), color: (!model.postsExercises.contains(type.name) ? null : Colors.grey), colorBlendMode: BlendMode.saturation,),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
