import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(
      {super.key,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      required this.theme,
      required this.onDateChanged});

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ThemeData theme;
  final Function(DateTime) onDateChanged;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: widget.theme.copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: widget.theme.colorScheme.primary,
              brightness: widget.theme.brightness,
            ),
            textTheme: TextTheme(
              bodyMedium: widget.theme.textTheme.bodyMedium,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    widget.theme.colorScheme.primary, // Color del texto
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;
    widget.onDateChanged(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: _selectDate,
        icon: const Icon(
          Icons.calendar_today,
          color: Colors.white));
  }
}
