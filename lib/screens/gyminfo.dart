import 'package:fitlife/models/model.dart';
import 'package:fitlife/resources/exercises.dart';
import 'package:fitlife/screens/classes/add_class.dart';
import 'package:fitlife/screens/classes/class_booking.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:fitlife/screens/upload_images.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube/youtube_thumbnail.dart';

class GymInfo extends StatefulWidget {
  const GymInfo({Key? key}) : super(key: key);

  @override
  State<GymInfo> createState() => _GymInfoState();
}

class _GymInfoState extends State<GymInfo> {
  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.gymInfo.isNotEmpty ? model.gymInfo[0] : 0}"),
        centerTitle: true,
        actions: [
          if(model.gymInfo.isNotEmpty)...[
            Visibility(
              visible: model.userInfo[3] != model.gymInfo[0] || model.userInfo[3] == "",
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  model.addUserGymInfo(model.gymInfo[0]);
                },
              ),
            ),
            Visibility(
              visible: model.userInfo[3] == model.gymInfo[0],
              child: IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Chat();
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: model.userInfo[3] == model.gymInfo[0] && model.userInfo[4] == "false",
              child: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const ClassBooking();
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: model.userInfo[3] == model.gymInfo[0] && model.userInfo[4] == "true",
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.calendarPlus),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AddClass();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.gymInfo.isNotEmpty)...[
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        if(model.userInfo[3] == model.gymInfo[0] && model.userInfo[4] == "true") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ImgurUploader();
                              },
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: (model.gymInfo[6].isNotEmpty) ? NetworkImage(model.gymInfo[6]) : null,
                          radius: 50
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Location: ${model.gymInfo[1]}\n"),
                        Text("Schedule:\n${model.gymInfo[5].replaceAll(",", ": ${model.gymInfo[2]}\n")}"),
                        Text("Price: ${model.gymInfo[3]} ${format.currencySymbol}\n"),
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            String email = Uri.encodeComponent(model.gymInfo[4]);
                            String subject = Uri.encodeComponent("I want to request some information about the gym");
                            Uri mail = Uri.parse("mailto:$email?subject=$subject");
                            await launch(mail.toString());
                          },
                          child: const Text("Mail us!", textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ] else...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
            StreamBuilder(
                stream: model.getPosts(),
                builder: (context, snapshot) {
                  final posts = (snapshot.data?.docs.where((doc) => (doc.data() as Map<String, dynamic>)["uploadedByAdmin"] == "true" && (doc.data() as Map<String, dynamic>)["gymName"] == model.userInfo[3]).toList() ?? []);
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
    );
  }
}
