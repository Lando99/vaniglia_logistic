

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vaniglia_logistic/screen/impostazioni/preference.dart';
/*
import 'utils.dart';


DateTime focusedDay = DateTime.now();

class TableEventsExample extends StatefulWidget {


  _SettingsFormState parent;


  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  ValueNotifier<List<Event>> _selectedEvents = null;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date





  DateTime _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }



  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }



  void _onDaySelected(DateTime selectedDay, DateTime focusedDay_aux) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        focusedDay = focusedDay_aux;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              print("cambio pagina $focusedDay");

              focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {



                if(value.length == 0){


                  return Center(
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(

                          onPressed: () {
                            setState(() {


                              kEvents.addAll(Map.fromIterable(List.generate(1, (index) => index),
                                  key: (item) => _selectedDay,
                                  value: (item) => List.generate(
                                      1, (index) => Event('Consegna')
                                  )
                              )
                              );
                              value.add(Event("Consegna"));

                            }


                            );

                          },
                          child: const Text('Aggiungi consegna'),
                        ),
                      ],
                    ),
                  );
                }

                // Genero la lista degli eventi
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );

                  },
                );
              },
            ),
          ),
        ],
      );
  }
}

 */