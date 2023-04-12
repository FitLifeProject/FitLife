import 'package:fitlife/models/model.dart';
import 'package:fitlife/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                icon: Icon(Icons.add),
                onPressed: () {
                  model.addUserGymInfo(model.gymInfo[0]);
                },
              ),
            ),
            Visibility(
              visible: model.userInfo[3] == model.gymInfo[0],
              child: IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Chat();
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
                    const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 50
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
              Center(
                child: CircularProgressIndicator(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
