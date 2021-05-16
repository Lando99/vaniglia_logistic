import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/services/auth.dart';

import '../../../constants.dart' as Constants;


/**
 * #Card Progression per visualizzazione degli ordini in Elaborazione
 * Si tratta di un widget che si occuoa di visualizzare la progressione degli ordini che sono in elebaorazione.
 *
 * Il widget e' composto anche da un bottone che permette di settare tutti gli ordini come completati
 * */

class CardProgressionElaborazione extends StatelessWidget {
  //Parametri passati alla card
  AuthService auth = null;
  List<Ordine> ordiniElaborazione = [];

  CardProgressionElaborazione({this.auth, this.ordiniElaborazione});


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Constants.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              label: Text('elabora'),
              icon: Icon(Icons.assignment_turned_in_outlined),
              onPressed: () {
                auth.setOrderConsegnato(ordiniElaborazione);
              },
            ),
          ),


          CircularPercentIndicator(
            radius: 120.0,
            lineWidth: 13.0,
            animation: true,
            percent: ordiniElaborazione.length == 0 ? 0 : ordiniElaborazione.length / 20,
            center: new Text(
              "${ordiniElaborazione.length}/20",
              style:
              new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            footer:
            Padding(
              padding: EdgeInsets.all(15),
              child: new Text(
                "completamento oridni",
                style:
                new TextStyle( fontSize: 17.0),
              ),
            ),


            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Constants.lightGreen,
          ),

        ],
      ),
    );
  }
}