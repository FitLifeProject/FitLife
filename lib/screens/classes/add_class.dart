import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fitlife/models/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _nameTextController = TextEditingController();
  final _limitTextController = TextEditingController();
  final _hoursTextController = TextEditingController();
  final _hours2Textcontroller = TextEditingController();

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  String dateVal = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      dateVal = _getValueText(CalendarDatePicker2Type.single, _singleDatePickerValueWithDefaultValue);
    });
  }

  String _getValueText(CalendarDatePicker2Type datePickerType, List<DateTime?> values,) {
    values = values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null).toString().replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty ? values.map((v) => v.toString().replaceAll('00:00:00.000', '')).join(', ') : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1 ? values[1].toString().replaceAll('00:00:00.000', '') : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<Model>();
    return WillPopScope(
        onWillPop: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Are you sure you don't want to publish the class you are going to teach?"),
              content: const Text("Important: If you exit everything will be discarded!"),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    dateVal = "";
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          );
      return result ?? false;
    },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(50),
          title: const Text("Add a new class"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if(dateVal.isNotEmpty && _nameTextController.text.isNotEmpty && _hoursTextController.text.isNotEmpty && _hours2Textcontroller.text.isNotEmpty && _limitTextController.text.isNotEmpty) {
                  model.addClass("${dateVal.replaceAll(" ", "")}_${_hoursTextController.text}-${_hours2Textcontroller.text}", "${_hoursTextController.text}-${_hours2Textcontroller.text}", _limitTextController.text, _nameTextController.text);
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final values = await showCalendarDatePicker2Dialog(
                    context: context,
                    config: CalendarDatePicker2WithActionButtonsConfig(
                      dayTextStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor: Colors.greenAccent,
                      closeDialogOnCancelTapped: true,
                      firstDayOfWeek: 1,
                      selectableDayPredicate: (day) => !day.difference(DateTime.now().subtract(const Duration(days: 1))).isNegative,
                      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
                      weekdayLabelTextStyle: const TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.bold,
                      ),
                      controlsTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      centerAlignModePicker: true,
                      customModePickerIcon: const SizedBox(),
                      selectedDayTextStyle: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      dayTextStylePredicate: ({required date}) {
                        TextStyle? textStyle;
                        if (date.weekday == DateTime.saturday ||
                            date.weekday == DateTime.sunday) {
                          textStyle = const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          );
                        }
                        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
                          textStyle = TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          );
                        }
                        return textStyle;
                      },
                      dayBuilder: ({
                        required date,
                        textStyle,
                        decoration,
                        isSelected,
                        isDisabled,
                        isToday,
                      }) {
                        Widget? dayWidget;
                        if (date.day % 3 == 0 && date.day % 9 != 0) {
                          dayWidget = Container(
                            decoration: decoration,
                            child: Center(
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Text(
                                    MaterialLocalizations.of(context).formatDecimal(date.day),
                                    style: textStyle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 27.5),
                                    child: Container(
                                      height: 4,
                                      width: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: isSelected == true
                                            ? Colors.white
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return dayWidget;
                      },
                      yearBuilder: ({
                        required year,
                        decoration,
                        isCurrentYear,
                        isDisabled,
                        isSelected,
                        textStyle,
                      }) {
                        return Center(
                          child: Container(
                            decoration: decoration,
                            height: 36,
                            width: 72,
                            child: Center(
                              child: Semantics(
                                selected: isSelected,
                                button: true,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      year.toString(),
                                      style: textStyle,
                                    ),
                                    if (isCurrentYear == true)
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(left: 5),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    dialogSize: const Size(325, 400),
                    borderRadius: BorderRadius.circular(15),
                    value: _singleDatePickerValueWithDefaultValue,
                    dialogBackgroundColor: Theme.of(context).backgroundColor,
                  );
                  if (values != null) {
                    setState(() {
                      dateVal = _getValueText(
                        CalendarDatePicker2Type.single,
                        values,
                      );
                      _singleDatePickerValueWithDefaultValue = values;
                    });
                  }
                },
                child: ListTile(
                  title: const Text('Date'),
                  subtitle: Text(dateVal),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  TimeRange? result = await showTimeRangePicker(
                    context: context,
                  );
                  setState(() {
                    _hoursTextController.text = "${result?.startTime.hour}:${result?.startTime.minute}";
                    _hours2Textcontroller.text = "${result?.endTime.hour}:${result?.endTime.minute}";
                  });
                },
                child: ListTile(
                  title: const Text('Class Hour'),
                  subtitle: Text("From ${_hoursTextController.text} to ${_hours2Textcontroller.text}"),
                ),
              ),
              ListTile(
                title: TextFormField(
                  controller: _nameTextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter class name',
                    hintText: 'Arterofilia',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Fill name field';
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                title: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _limitTextController,
                  decoration: const InputDecoration(
                    labelText: 'Enter the limit of people that can assist',
                    hintText: '10',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Fill limit field';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
