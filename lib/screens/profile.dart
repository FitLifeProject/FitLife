import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:fitlife/screens/exercise_posts.dart';
import 'package:fitlife/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube/youtube_thumbnail.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
          leading: IconButton(
            icon: Image.asset("assets/img/fitlife.png"),
            onPressed: () {
            },
          ),
          title: Text("Profile of: ${model.userInfo[0]}"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                if (model.userInfo[3] != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Chat();
                      },
                    ),
                  );
                } else {
                  model.showSnackbar(context, "You must join to a Gym");
                }
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: model.getPosts(),
                builder: (context, snapshot) {
                  final posts = (snapshot.data?.docs.where((doc) => (doc.data() as Map<String, dynamic>)["publisher"] == model.userInfo[1]).toList() ?? []);
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        List exerciseStr = [];
                        List<Exercises> exercises = [];
                        List reps = [];
                        List sets = [];
                        if(posts.isNotEmpty) {
                          exerciseStr = posts[index]['exercises'].split(",");
                          for (String exerciseString in exerciseStr) {
                            Exercises exercise = strToExercise[exerciseString] ?? Exercises.none;
                            exercises.add(exercise);
                          }
                          reps = posts[index]['reps'].split(",");
                          sets = posts[index]['sets'].split(",");
                        }
                        if(snapshot.hasError) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 3),
                                    Text(
                                        (posts[index]['uploadedByAdmin'] == "false") ? posts[index]['name'] : "Published by: Trainer for: ${posts[index]['name']}",
                                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)
                                    ),
                                    Text(
                                        "${posts[index]['gymName']} · ${DateFormat("dd/MM/yyyy HH:mm:ss").format((posts[index]['timestamp'].toDate()))}",
                                        style: const TextStyle(fontSize: 14.0, color: Colors.grey)
                                    ),
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
                                            Text(
                                              "Reps: ${reps[index]} Sets: ${sets[index]}",
                                              style: const TextStyle(fontSize: 16.0),
                                            ),
                                            const SizedBox(height: 5),
                                            GestureDetector(
                                              onTap: () async {
                                                await launch(exercises[index].url);
                                              },
                                              child: Image.network(YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).standard()),
                                            ),
                                            const SizedBox(height: 3),
                                          ],
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    Visibility(
                                      visible: posts[index]['title'].toString().isNotEmpty && posts[index]['content'].toString().isNotEmpty,
                                      child: Column(
                                        children: [
                                          Text(
                                            posts[index]['title'],
                                            style: const TextStyle(fontSize: 36.0),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                              posts[index]['content']
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            content: const Text("Are you sure that you want to delete that message?"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("No"),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                              TextButton(
                                                child: const Text("Yes"),
                                                onPressed: () {
                                                  if(model.userInfo[4] == "true") {
                                                    model.fb_store.runTransaction((transaction) async => transaction.delete(snapshot.data!.docs[index].reference));
                                                  } else {
                                                    snapshot.data!.docs[index].reference.get().then((value) {
                                                      if(value.get("senderMail") == model.auth.currentUser?.email) {
                                                        model.fb_store.runTransaction((transaction) async => transaction.delete(snapshot.data!.docs[index].reference));
                                                      }
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                  );
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(model, context),
    );
  }
}
