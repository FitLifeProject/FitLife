import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:fitlife/screens/exercise/add_benchmark.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube/youtube_thumbnail.dart';

class Benchmark extends StatefulWidget {
  const Benchmark({Key? key}) : super(key: key);

  @override
  State<Benchmark> createState() => _BenchmarkState();
}

class _BenchmarkState extends State<Benchmark> {
  bool moreThanOneExercise = false;

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Benchmarks"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AddBenchmark();
                  },
                )
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: model.getBenchmarks(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final posts = snapshot.data!.docs;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          List exerciseStr = [];
                          List<Exercises> exercises = [];
                          List oldReps = [];
                          List oldSets = [];
                          List reps = [];
                          List sets = [];
                          if(posts.isNotEmpty) {
                            exerciseStr = posts[index]['exercises'].split(",");
                            for (String exerciseString in exerciseStr) {
                              Exercises exercise = strToExercise[exerciseString] ?? Exercises.none;
                              exercises.add(exercise);
                            }
                            if(posts[index]['previous_reps'].contains(",") && posts[index]['previous_sets'].contains(",") && posts[index]['reps'].contains(",") && posts[index]['sets'].contains(",")) {
                              oldReps = posts[index]['previous_reps'].split(",");
                              oldSets = posts[index]['previous_sets'].split(",");
                              reps = posts[index]['reps'].split(",");
                              sets = posts[index]['sets'].split(",");
                              setState(() => moreThanOneExercise = true);
                            }
                          }
                          if(snapshot.hasError) {
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 2.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: exercises.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              Text(
                                                exercises[index].name,
                                                style: const TextStyle(fontSize: 36.0),
                                              ),
                                              const SizedBox(height: 5),
                                              if (moreThanOneExercise)...[
                                                Text(
                                                  "Reps: ${oldReps[index]} -> ${reps[index]}",
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                                Text(
                                                  "Sets: ${oldSets[index]} -> ${sets[index]}",
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ] else ...[
                                                Text(
                                                  "Reps: ${posts[index]['previous_reps']} -> ${posts[index]['reps']}",
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                                Text(
                                                  "Sets: ${posts[index]['previous_sets']} -> ${posts[index]['sets']}",
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () async {
                                                  await launch(exercises[index].url);
                                                },
                                                child: Image.network(YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).standard()),
                                              ),
                                              const SizedBox(height: 6),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                    DateFormat("dd/MM/yyyy HH:mm:ss").format((posts[index]['timestamp'].toDate())),
                                                    style: const TextStyle(fontSize: 14.0, color: Colors.grey)
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                    );
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
