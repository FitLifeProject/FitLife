import 'package:fitlife/models/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookedClasses extends StatefulWidget {
  const BookedClasses({Key? key}) : super(key: key);

  @override
  State<BookedClasses> createState() => _BookedClassesState();
}

class _BookedClassesState extends State<BookedClasses> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text((model.userInfo[4] == "true") ? "Classes held at ${model.userInfo[3]}" : "Booked classes of ${model.userInfo[0]}"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: model.getMyClasses(),
        builder: (context, snapshot) {
          final classes = (snapshot.data?.docs ?? []);
          if(!snapshot.hasData) {
            return Center(child: ListTile(title: Text((model.userInfo[4] == "true") ? "No classes have been held at ${model.userInfo[3]}" : "You haven't booked any class.")));
          } else {
            return ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(classes[index].id),
                    title: Text(classes[index]["name"]),
                  );
                }
            );
          }
        },
      ),
    );
  }
}
