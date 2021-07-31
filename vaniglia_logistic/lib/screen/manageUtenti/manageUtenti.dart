import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/authenticate/register.dart';
import 'package:vaniglia_logistic/screen/manageUtenti/lista_utenti.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/services/database.dart';
import 'package:vaniglia_logistic/shared/loading.dart';
import 'package:vaniglia_logistic/shared/makeDrawer.dart';
import 'package:vaniglia_logistic/shared/routes.dart';

import '../../constants.dart' as Constants;

class ManageUtenti extends StatefulWidget {
  static const String routeName = "/ManageUtenti";
  @override
  _ManageUtentiState createState() => _ManageUtentiState();
}

class _ManageUtentiState extends State<ManageUtenti> {
  final AuthService _auth = AuthService();
  // Inizializzazione del utente con cui ho fatto l'accesso.
  // l'Utente contine l'informazione email per la stampa grafica e l'attributo di ruolo in modo da indentificare
  // all'interno del programma se l'utente con cui si ha fatto accesso e' un utente amministratore oppure un utente standart
  final CollectionReference utenti = FirebaseFirestore.instance.collection('utenti');



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(

      future: utenti.doc("6zBY9abmApXd4MMyIIZGSh819kF3").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {


          Map<String, dynamic> data = snapshot.data.data();

          Utente _user = Utente(uid: data.keys.toString(), email: data['email'], ruolo: data['ruolo'] );

          return StreamProvider<List<Utente>>.value(
            initialData: [],
            value: DatabaseService().utentiStream,
            child: Scaffold(
              backgroundColor: Constants.mediumBrown,
              appBar: AppBar(
                title: Text('Utenti'),
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
              body: ListaUtenti(),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.person_add_alt_1_outlined),
                backgroundColor: Constants.red,
                onPressed: (){
                  Navigator.pushNamed(context, Register.routeName);
                },
              ),

            ),
          );

        }else{
           Loading();
        }

        return Loading();
      },
    );
  }
}
