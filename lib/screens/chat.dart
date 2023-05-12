import 'package:fitlife/models/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool edit = false;
  int editDoc = 0;
  List<String> message = [];
  List<String> sender = [];
  int index = 0;
  var uniqueSet = <String>{};

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
        title: Column(
          children: [
            const Text("Chat"),
            Text(
              "${model.users.toString()} users",
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: model.getMessages(),
                builder: (context, snapshot) {
                  final messages = (snapshot.data?.docs ?? []);
                  index = messages.length;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.hasError) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          child: Align(alignment: ((messages[index].get("senderMail") != model.auth.currentUser?.email) ? Alignment.topLeft : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ((messages[index].get("senderMail") != model.auth.currentUser?.email) ? Colors.black : Colors.green),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child:
                                GestureDetector(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(messages[index]['sender'], style: const TextStyle(fontSize: 10)),
                                      Text(messages[index]['message'], style: const TextStyle(fontSize: 15)),
                                      Text((messages[index]['modified'].toString() == "true") ? "${DateFormat("HH:mm:ss").format((messages[index]['timestamp'].toDate())).toString()} (modified)" : DateFormat("HH:mm:ss").format((messages[index]['timestamp'].toDate())).toString(), style: const TextStyle(fontSize: 8))
                                    ],
                                  ),
                                  onDoubleTap: () {
                                    snapshot.data!.docs[index].reference.get().then((value) {
                                      if(value.get("senderMail") == model.auth.currentUser?.email) {
                                        textEditingController.text = value.get("message");
                                        edit = true;
                                        editDoc = int.parse(value.id.substring(3, value.id.length));
                                      }
                                    });
                                  },
                                  onLongPress: () {
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
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
            child: TextField(
              focusNode: focusNode,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              controller: textEditingController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                hintText: 'Write your message',
                suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.inverseSurface,
                    onPressed: () {
                      (!edit) ? model.sendMsg(textEditingController.text, ++index, !edit) : model.sendMsg(textEditingController.text, editDoc, edit);
                      edit = false;
                      editDoc = 0;
                      textEditingController.clear();
                    }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
