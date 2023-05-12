import 'package:fitlife/models/model.dart';
import 'package:fitlife/screens/gyminfo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GymResults extends StatefulWidget {
  final dynamic gyms;
  const GymResults({Key? key, required this.gyms}) : super(key: key);

  @override
  State<GymResults> createState() => _GymResultsState();
}

class _GymResultsState extends State<GymResults> {
  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Results of your search"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.gyms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: TextButton(
                child: Text(widget.gyms[index]),
                onPressed: () {
                  model.getGymInfo(widget.gyms[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const GymInfo();
                      },
                    ),
                  );
                },
            ),
          );
        },
      )
    );
  }
}
