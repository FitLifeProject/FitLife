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
        title: Text("Booked classes of ${model.userInfo[0]}"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: model.getMyClasses(),
        builder: (context, snapshot) {
          final classes = (snapshot.data?.docs ?? []);
          if(!snapshot.hasData) {
            return const Center(child: ListTile(title: Text("You haven't booked any class.")));
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
