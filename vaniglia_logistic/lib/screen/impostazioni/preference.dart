import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vaniglia_logistic/models/evento.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/services/database.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import '../../constants.dart' as Constants;
import 'package:vaniglia_logistic/screen/impostazioni/events_example.dart';

import 'package:vaniglia_logistic/shared/makeDrawer.dart';

import 'utils.dart';


class SettingsForm extends StatefulWidget {
  static const String routeName = "/SettingsForm";
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {




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
      StreamProvider<List<Evento>>.value(
          value: DatabaseService().eventiCalendarioStream( focusedDay.year, focusedDay.month),
          initialData: [],
          builder: (context, snapshot) {


            List<Evento> eventi = Provider.of<List<Evento>>(context);


            eventi.forEach((element) =>

                kEvents.addAll(Map.fromIterable(List.generate(1, (index) => index),
                    key: (item) => element.date.toDate(),
                    value: (item) => List.generate(
                        1, (index) => Event('Consegna')
                    )
                ))



            );



            return TableEventsExample(parent: this,);
          }
      ),
      //TableEventsExample()

    );
  }
}




DateTime focusedDay = DateTime.now();

class TableEventsExample extends StatefulWidget {


  _SettingsFormState parent;
  TableEventsExample({this.parent});
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

        /*
        widget.parent.setState(() {

        });

         */


      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }



  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();

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
          onPageChanged: (focusedDay_aux) {

            widget.parent.setState(() {

            });
            focusedDay = focusedDay_aux;


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


                          Evento e = Evento(id: "consegna "+ _selectedDay.day.toString(), date: Timestamp.fromDate(_selectedDay));
                          DatabaseService(uid: _auth.getUid()).updateEventi(e);

                          //dynamic result = await DatabaseService.updateUser(Evento e);

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



