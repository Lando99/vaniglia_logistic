import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/home/homeComponets/CardStatistic.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/shared/loading.dart';
import 'package:vaniglia_logistic/shared/makeDrawer.dart';
import 'package:vaniglia_logistic/services/database.dart';



import '../../constants.dart' as Constants;
import 'homeComponets/CardProgressionElaborazione.dart';

import 'package:vaniglia_logistic/shared/globals.dart' as globals;

class Home extends StatefulWidget {

  static const String routeName = "/Home";

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  final CollectionReference utenti = FirebaseFirestore.instance.collection('utenti');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: utenti.doc(_auth.getUid()).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {


          Map<String, dynamic> data = snapshot.data.data();
          globals.user = Utente(uid: data.keys.toString(), email: data['email'], ruolo: data['ruolo'] );

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
            drawer: MakeDrawer(),
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
                        CardProgressionElaborazione(auth: _auth,ordiniElaborazione: ordiniElaborazione),
                        SizedBox(height: 10),
                        CardStatistic(parent: this,)
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





