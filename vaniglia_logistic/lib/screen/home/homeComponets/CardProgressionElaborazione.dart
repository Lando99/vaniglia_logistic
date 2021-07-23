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
 * Il widget e' composto anche da un bottone che permette di settare tutti gli ordini in eleborazione a complietati con un solo click
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

      child: Container(
        width: double.infinity,
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Ordini in elaborazione", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.7), fontSize: 24)),
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
                child:


                ElevatedButton.icon(
                  label: Text('elabora'),
                  icon: Icon(Icons.assignment_turned_in_outlined),
                  onPressed: () {
                    auth.setOrderConsegnato(ordiniElaborazione);
                  },
                ),




              ),


              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Constants.lightGreen,
            ),

          ],
        ),
      ),
    );
  }
}