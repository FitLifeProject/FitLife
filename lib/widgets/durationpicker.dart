import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;
  final EdgeInsets? titlePadding;
  final Widget title;
  final Widget confirmWidget;
  final Widget cancelWidget;

  const DurationPickerDialog({
    super.key,
    required this.initialDuration,
    required this.title,
    this.titlePadding,
    Widget? confirmWidget,
    Widget? cancelWidget,
  })  : confirmWidget = confirmWidget ?? const Text('OK'),
        cancelWidget = cancelWidget ?? const Text('CANCEL');

  @override
  State<StatefulWidget> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late int minutes;
  late int seconds;

  @override
  void initState() {
    super.initState();
    minutes = widget.initialDuration.inMinutes;
    seconds = widget.initialDuration.inSeconds % Duration.secondsPerMinute;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        NumberPicker(
          itemWidth: 65,
          value: minutes,
          minValue: 0,
          maxValue: 10,
          zeroPad: true,
          onChanged: (value) {
            setState(() {
              minutes = value;
            });
          },
        ),
        const Text(
          ':',
          style: TextStyle(fontSize: 30),
        ),
        NumberPicker(
          itemWidth: 65,
          value: seconds,
          minValue: 0,
          maxValue: 59,
          zeroPad: true,
          onChanged: (value) {
            setState(() {
              seconds = value;
            });
          },
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(Duration(minutes: minutes, seconds: seconds)),
          child: widget.confirmWidget,
        ),
      ],
    );
  }
}
