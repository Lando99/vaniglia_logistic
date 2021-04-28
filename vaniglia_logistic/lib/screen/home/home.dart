import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/authenticate/register.dart';
import 'package:vaniglia_logistic/screen/order/selectUtente.dart';
import 'package:vaniglia_logistic/screen/services/auth.dart';
import 'package:vaniglia_logistic/shared/loading.dart';
import 'package:vaniglia_logistic/shared/makeDrawer.dart';
import 'package:vaniglia_logistic/screen/services/database.dart';
import 'package:vaniglia_logistic/screen/home/lista_utenti.dart';
import 'package:vaniglia_logistic/shared/routes.dart';



import '../../constants.dart' as Constants;




class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  // Inizializzazione del utente con cui ho fatto l'accesso.
  // l'Utente contine l'informazione email per la stampa grafica e l'attributo di ruolo in modo da indentificare
  // all'interno del programma se l'utente con cui si ha fatto accesso e' un utente amministratore oppure un utente standart
  final CollectionReference utenti = FirebaseFirestore.instance.collection('utenti');
  static const String routeName = "/Home";






  @override
  Widget build(BuildContext context) {




    return FutureBuilder<DocumentSnapshot>(
      future: utenti.doc(_auth.getUid()).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data.data();

          Utente _user = Utente(uid: data.keys.toString(), email: data['email'], ruolo: data['ruolo'] );
          Routes.utente = Utente(uid: data.keys.toString(), email: data['email'], ruolo: data['ruolo'] );

          //notification();

          return Scaffold(
            backgroundColor: Constants.mediumBrown,

            appBar: AppBar(
              title: Text('Home'),
              backgroundColor: Constants.darkBrown,
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: ()async{
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Logout"),)
              ],
            ),
            drawer: MakeDrawer(_user),
            body: StreamProvider<List<Ordine>>.value(
                value: DatabaseService().ordiniStream,
                initialData: [],
                builder: (context, snapshot) {


                  List<Ordine> ordini = Provider.of<List<Ordine>>(context);


                  List<Ordine> ordiniElaborazione = [];
                  ordini.forEach((element) => element.stato == "elaborazione" ? ordiniElaborazione.add(element) : null);


                  return Padding(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Card(
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
                                    _auth.setOrderConsegnato(ordiniElaborazione);

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
                        ),


                      ],
                    ),
                  );
                }
            ),
          );

        }else{
          return Loading();
        }
      },
    );



  }
}




