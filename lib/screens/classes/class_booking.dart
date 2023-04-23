import 'package:fitlife/models/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassBooking extends StatefulWidget {
  const ClassBooking({Key? key}) : super(key: key);

  @override
  State<ClassBooking> createState() => _ClassBookingState();
}

class _ClassBookingState extends State<ClassBooking> {
  var today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
        title: const Text("Calendar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: "en_US",
            firstDay: DateTime.utc(2022, 12, 31),
            lastDay: DateTime.utc(2024, 01, 01),
            focusedDay: today,
            selectedDayPredicate: (day) => isSameDay(day, today),
            onDaySelected: _onDaySelected,
            calendarFormat: CalendarFormat.week,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
          ),
          StreamBuilder(
            stream: model.getClasses(),
            builder: (context, snapshot) {
              final classes = (snapshot.data?.docs ?? []);
              final filteredClasses = classes.where((cla) => cla.id.contains(today.toString().split(" ")[0])).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredClasses.length,
                itemBuilder: (BuildContext context, int index) {
                  String documentName = filteredClasses[index].id;
                  if(snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if(today.isBefore(DateTime.now())) {
                      return IgnorePointer(
                        ignoring: true,
                        child: AbsorbPointer(
                          absorbing: true,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  color: Theme.of(context).backgroundColor.withOpacity(0.5),
                                ),
                              ),
                              ListTile(
                                title: Text("${filteredClasses[index]['name']}"),
                                subtitle: Text("${filteredClasses[index]['hour']}"),
                                trailing: TextButton(
                                  onPressed: () {
                                    if(filteredClasses[index]['users'].contains(model.userInfo[1])) {
                                      model.bookClass(documentName, false);
                                    } else {
                                      model.bookClass(documentName, true);
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Text(!filteredClasses[index]['users'].contains(model.userInfo[1]) ? "Book" : "Cancel book"),
                                      Text("${filteredClasses[index]['users'].length}/${filteredClasses[index]['limit']}"),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          )
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Text("${filteredClasses[index]['name']}"),
                        subtitle: Text("${filteredClasses[index]['hour']}"),
                        trailing: TextButton(
                          onPressed: () {
                            if(filteredClasses[index]['users'].contains(model.userInfo[1])) {
                              model.bookClass(documentName, false);
                            } else {
                              model.bookClass(documentName, true);
                            }
                          },
                          child: Column(
                            children: [
                              Text(!filteredClasses[index]['users'].contains(model.userInfo[1]) ? "Book" : "Cancel book"),
                              Text("${filteredClasses[index]['users'].length}/${filteredClasses[index]['limit']}"),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                },
              );
            }
          ),
        ]
      ),
    );
  }
}
