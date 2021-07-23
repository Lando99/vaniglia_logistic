import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constants.dart' as Constants;
import 'events_example.dart';
import 'utils.dart';


class SettingsForm extends StatefulWidget {
  static const String routeName = "/SettingsForm";
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  // Variabili del calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightBrown,
      appBar: AppBar(
          backgroundColor: Constants.lightBrown,
          elevation: 0.0,
          title: Center(
            child: Text('Impostazioni - ( BETA ) -', style: TextStyle(color: Colors.black),),
          ),
          leading:
          IconButton(
            icon: const Icon(Icons.vertical_align_bottom, color: Colors.black,),
            onPressed: () { Navigator.pop(context);
            },
          )
      ),
      body:
      TableEventsExample()
/*
      TableCalendar(
        firstDay: DateTime.utc(2021, 7, 1),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),

 */

    );
  }
}





