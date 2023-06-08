import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:fitlife/screens/exercise_posts.dart';
import 'package:fitlife/widgets/web_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube/youtube_thumbnail.dart';

class PR extends StatefulWidget {
  const PR({Key? key}) : super(key: key);

  @override
  State<PR> createState() => _PRState();
}

class _PRState extends State<PR> {
  ExercisesType _selectedType = ExercisesType.gymnastics;

  Widget _buildTypeButton(ExercisesType type) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Text(type.name, style: TextStyle(color: _selectedType == type ? Theme.of(context).colorScheme.primary.withGreen(255) : Theme.of(context).colorScheme.secondary)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("PR"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: _buildTypeButton(ExercisesType.gymnastics),
                    ),
                    TableCell(
                      child: _buildTypeButton(ExercisesType.strength),
                    ),
                    TableCell(
                      child: _buildTypeButton(ExercisesType.strengthening),
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ExercisePosts();
                    },
                  ),
                );
              },
              child: const Text('Register a new mark'),
            ),
            StreamBuilder(
              stream: model.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final posts = snapshot.data!.docs.where((doc) => doc["gymName"] == model.userInfo[3] && doc["publisher"] == model.userInfo[1]).toList();
                  final filteredPosts = posts.where((post) {
                    final exercises = (post.data() as Map<String, dynamic>)["exercises"].split(",");
                    return exercises.any((exerciseStr) {
                      final exercise = strToExercise[exerciseStr];
                      return exercise != null && exercise.type == _selectedType;
                    });
                  }).toList();
                  if (filteredPosts.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = filteredPosts[index];
                          final exercises = (post.data() as Map<String, dynamic>)["exercises"].split(",");
                          final reps = (post.data() as Map<String, dynamic>)["reps"].split(",");
                          final sets = (post.data() as Map<String, dynamic>)["sets"].split(",");
                          final values = (post.data() as Map<String, dynamic>)["values"].split(",");
                          final filteredExercises = exercises.where((exerciseStr) {
                            final exercise = strToExercise[exerciseStr];
                            return exercise != null && exercise.type == _selectedType;
                          }).toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredExercises.length,
                            itemBuilder: (BuildContext context, int index) {
                              final exercise = strToExercise[filteredExercises[index]]!;
                              final rep = reps[exercises.indexOf(filteredExercises[index])];
                              final set = sets[exercises.indexOf(filteredExercises[index])];
                              final value = values[exercises.indexOf(filteredExercises[index])];
                              final valTitle;
                              if(exercise.measuresType != MeasuresType.reps && exercise.measuresType == MeasuresType.lbs) {
                                valTitle = "Lbs";
                              } else if(exercise.measuresType != MeasuresType.reps && exercise.measuresType == MeasuresType.seconds) {
                                valTitle = "Seconds";
                              } else if(exercise.measuresType != MeasuresType.reps && exercise.measuresType == MeasuresType.meters) {
                                valTitle = "Meters";
                              } else {
                                valTitle = "";
                              }
                              return Column(
                                children: [
                                  if(exercise.measuresType != MeasuresType.reps)...[
                                    ListTile(
                                      leading: GestureDetector(
                                        onTap: () async {
                                          await launch(exercise.url);
                                        },
                                        child: (kIsWeb) ? WebImage(imageSrc: YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).standard(), height: 240, width: 320) : Image.network(YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).standard()),
                                      ),
                                      title: Text(exercise.name, style: const TextStyle(fontSize: 24.0),),
                                      subtitle: Text("Sets: $set Reps: $rep $valTitle: $value", style: const TextStyle(fontSize: 16.0),),
                                    ),
                                  ] else...[
                                    ListTile(
                                      leading: GestureDetector(
                                        onTap: () async {
                                          await launch(exercise.url);
                                        },
                                        child: (kIsWeb) ? WebImage(imageSrc: YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).standard(), height: 240, width: 320) : Image.network(YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).standard()),
                                      ),
                                      title: Text(exercise.name, style: const TextStyle(fontSize: 24.0),),
                                      subtitle: Text("Sets: $set Reps: $rep", style: const TextStyle(fontSize: 16.0),),
                                    ),
                                  ]
                                ],
                              );
                            },
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("There are not PR's at this filter."),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
