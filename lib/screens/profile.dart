import 'dart:io';
import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:fitlife/screens/exercise/benchmark.dart';
import 'package:fitlife/screens/home.dart';
import 'package:fitlife/screens/upload_images.dart';
import 'package:fitlife/screens/exercise/pr.dart';
import 'package:fitlife/widgets/bottom_navigation.dart';
import 'package:fitlife/widgets/web_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              model.changeScreen(0);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const Home();
                  },
                ),
              );
            },
          ),
          title: const Text("Profile"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                if (model.userInfo[3] != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Chat();
                      },
                    ),
                  );
                } else {
                  model.showSnackbar(context, "You must join to a Gym");
                }
              },
            ),
          ]),
      body: WillPopScope(
        onWillPop: () async {
          bool result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Are you sure you want to exit from Fitlife?"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    model.signOut;
                    if (Platform.isIOS) {
                      exit(0);
                    } else if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    }
                  },
                ),
              ],
            ),
          );
          return result;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 2.0),
                child: Card(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      GestureDetector(
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ImgurUploader(pfp: true,);
                              },
                            ),
                          );
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage: (model.userInfo[5].isNotEmpty) ? NetworkImage(model.userInfo[5]) : null,
                            radius: 50
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(model.userInfo[0]),
                      const SizedBox(height: 10,),
                      Text(model.userInfo[6]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(FontAwesomeIcons.medal),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const PR();
                                        },
                                      ),
                                    );
                                  }
                              ),
                              const Text("PR's")
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  icon: const Icon(FontAwesomeIcons.dumbbell),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Benchmark();
                                        },
                                      ),
                                    );
                                  }
                              ),
                              const Text("Benchmarks")
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ),
              ),
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
                          List values = [];
                          if(posts.isNotEmpty) {
                            exerciseStr = posts[index]['exercises'].split(",");
                            for (String exerciseString in exerciseStr) {
                              Exercises exercise = strToExercise[exerciseString] ?? Exercises.none;
                              exercises.add(exercise);
                            }
                            reps = posts[index]['reps'].split(",");
                            sets = posts[index]['sets'].split(",");
                            values = posts[index]['values'].split(",");
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
                                              if(exercises[index].measuresType != MeasuresType.reps)...[
                                                if(exercises[index].measuresType == MeasuresType.lbs)...[
                                                  Text(
                                                    "Sets: ${sets[index]} Reps: ${reps[index]} lbs: ${values[index]}",
                                                    style: const TextStyle(fontSize: 16.0),
                                                  ),
                                                ] else if(exercises[index].measuresType == MeasuresType.seconds)...[
                                                  Text(
                                                    "Sets: ${sets[index]} Reps: ${reps[index]} Seconds: ${values[index]}",
                                                    style: const TextStyle(fontSize: 16.0),
                                                  ),
                                                ] else if(exercises[index].measuresType == MeasuresType.meters)...[
                                                  Text(
                                                    "Sets: ${sets[index]} Reps: ${reps[index]} Meters: ${values[index]}",
                                                    style: const TextStyle(fontSize: 16.0),
                                                  ),
                                                ],
                                              ] else...[
                                                Text(
                                                  "Sets: ${sets[index]} Reps: ${reps[index]}",
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                              ],
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () async {
                                                  await launch(exercises[index].url);
                                                },
                                                child: (kIsWeb) ? WebImage(imageSrc: YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).hq(), height: 480, width: 640) : Image.network(YoutubeThumbnail(youtubeId:  exercises[index].url.replaceRange(0, 17, "")).hq()),
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
                                              content: const Text("Are you sure that you want to delete that training?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("No"),
                                                  onPressed: () => Navigator.pop(context),
                                                ),
                                                TextButton(
                                                  child: const Text("Yes"),
                                                  onPressed: () {
                                                    if(model.userInfo[4] == "true") {
                                                      model.fbStore.runTransaction((transaction) async => transaction.delete(snapshot.data!.docs[index].reference));
                                                    } else {
                                                      snapshot.data!.docs[index].reference.get().then((value) {
                                                        if(value.get("senderMail") == model.auth.currentUser?.email) {
                                                          model.fbStore.runTransaction((transaction) async => transaction.delete(snapshot.data!.docs[index].reference));
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
      ),
      bottomNavigationBar: bottomNavBar(model, context),
    );
  }
}
