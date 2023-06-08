import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:fitlife/widgets/grayedout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youtube/youtube_thumbnail.dart';

class ExercisePosts extends StatefulWidget {
  const ExercisePosts({Key? key}) : super(key: key);

  @override
  State<ExercisePosts> createState() => _ExercisePostsState();
}

class _ExercisePostsState extends State<ExercisePosts> {
  final allTypes = Exercises.values;
  final _titleTextController = TextEditingController();
  final _contentTextController = TextEditingController();
  String name = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    void onChanged(value) {
      model.modifySelectedEmail(value);
      name = model.nameEmailCombinedValue.split(" - ")[0];
      email = model.nameEmailCombinedValue.split(" - ")[1];
    }
    List<TextEditingController> setsControllers = [];
    List<TextEditingController> repsControllers = [];
    List<TextEditingController> valuesControllers = [];
    for (int i = 0; i < model.postsExercises.length; i++) {
      setsControllers.add(TextEditingController());
      repsControllers.add(TextEditingController());
      valuesControllers.add(TextEditingController());
    }
    String exercises = "";
    List sets = [];
    List reps = [];
    List values = [];
    return WillPopScope(
      onWillPop: () async {
        var result = false;
        if(model.addingPostExerciseScreen == 1 || model.addingPostExerciseScreen == 2) {
          model.setAddingPostExerciseScreen(0);
        } else {
          result = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: const Text(
                      "Are you sure you don't want post the exercise you have done?"),
                  content: const Text(
                      "Important: If you exit everything will be discarded!"),
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
                        sets = [];
                        reps = [];
                        values = [];
                        if (model.userInfo[4] == "true") {
                          if (!model.postToAddIsForAdmin) {
                            model.setForAdmin();
                          }
                        }
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
              ),
          );
        }
        return result;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () =>  {
              if(model.addingPostExerciseScreen == 1 || model.addingPostExerciseScreen == 2) {
                model.setAddingPostExerciseScreen(0)
              } else {
                Navigator.pop(context)
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text("Add posts"),
          centerTitle: true,
          actions: [
            Visibility(
              visible: model.addingPostExerciseScreen == 1 || model.addingPostExerciseScreen == 2,
              child: IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  if (model.addingPostExerciseScreen == 2 && _titleTextController.text.isNotEmpty && _contentTextController.text.isNotEmpty) {
                    model.setAddingPostExerciseScreen(0);
                  } else if (model.addingPostExerciseScreen == 1 && model.postsExercises.isNotEmpty) {
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
                  reps = [];
                  sets = [];
                  values = [];
                  for (int i = 0; i < model.postsExercises.length; i++) {
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
                    if(exercises.isNotEmpty && reps.isNotEmpty && sets.isNotEmpty) {
                      if(model.userInfo[4] == "true" && model.postToAddIsForAdmin || model.userInfo[4] == "false") {
                        if(_titleTextController.text.isNotEmpty && _contentTextController.text.isNotEmpty) {
                          model.sendPost(exercises, reps.join(","), sets.join(","), values.join(","), title: _titleTextController.text, content: _contentTextController.text);
                        } else {
                          model.sendPost(exercises, reps.join(","), sets.join(","), values.join(","));
                        }
                      } else if(model.userInfo[4] == "true" && !model.postToAddIsForAdmin) {
                        if (_titleTextController.text.isNotEmpty && _contentTextController.text.isNotEmpty) {
                          model.sendPost(exercises, reps.join(","), sets.join(","), values.join(","), pName: name, pEmail: email, title: _titleTextController.text, content: _contentTextController.text);
                        } else {
                          model.sendPost(exercises, reps.join(","), sets.join(","), values.join(","), pName: name, pEmail: email);
                        }
                      }
                      model.addRemExercise("", clear: true);
                      reps = [];
                      sets = [];
                      values = [];
                      if(model.userInfo[4] == "true") {
                        if(!model.postToAddIsForAdmin) {
                          model.setForAdmin();
                        }
                      }
                      model.setAddingPostExerciseScreen(0);
                      Navigator.pop(context);
                    } else {
                      if(exercises.isEmpty) {
                        model.showSnackbar(context, "You must choose at least 1 exercise.");
                      } else if(reps.isEmpty || sets.isEmpty) {
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
                                  const SizedBox(width: 4),
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
                GestureDetector(
                  onTap: () {
                    model.setAddingPostExerciseScreen(2);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Add an additional message"),
                    trailing: Icon(Icons.arrow_forward_outlined),
                  ),
                ),
                Visibility(
                  visible: model.userInfo[4] == "true",
                  child: GrayedOut(
                    grayedOut: model.nameEmailCombinedValue.isEmpty,
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text("Is this post for an admin?"),
                      trailing: Switch(
                        value: model.postToAddIsForAdmin,
                        onChanged: model.nameEmailCombinedValue.isEmpty ? null : (bool newValue) {
                          model.setForAdmin();
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey,
                        activeTrackColor: Colors.lightGreen,
                      ),
                    ),
                  ),
                ),
                if (model.nameEmailCombined.isNotEmpty) ...[
                  Visibility(
                    visible: model.userInfo[4] == "true" && !model.postToAddIsForAdmin,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButton<String>(
                          value: model.nameEmailCombinedValue,
                          items: model.nameEmailCombined.map((nameMail) {
                            return DropdownMenuItem<String>(
                              value: nameMail,
                              child: Text(nameMail),
                            );
                          }).toList(),
                          onChanged: onChanged,
                          iconEnabledColor: Colors.white,
                          underline: Container(),
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ]
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
              ] else if (model.addingPostExerciseScreen == 2) ...[
                TextField(
                  controller: _titleTextController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Title",
                    suffixText: "Title",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                TextField(
                  controller: _contentTextController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Content",
                    suffixText: "Content",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
