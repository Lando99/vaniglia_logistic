import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/authenticate/authenticate.dart';
import 'package:vaniglia_logistic/screen/authenticate/register.dart';
import 'package:vaniglia_logistic/screen/deliveries/deliveries.dart';
import 'package:vaniglia_logistic/screen/home/Ordini.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';
import 'package:vaniglia_logistic/screen/manageUtenti/manageUtenti.dart';
import 'package:vaniglia_logistic/screen/order/makeOrder.dart';
import 'package:vaniglia_logistic/screen/order/selectUtente.dart';
import 'package:vaniglia_logistic/screen/services/auth.dart';
import 'screen/order/makeQuantity.dart';
import 'screen/order/confirmOrder.dart';

import 'screen/home/preference.dart';

import 'package:firebase_core/firebase_core.dart';
import 'screen/home/Ordini.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  var routes = <String, WidgetBuilder>{
    Home.routeName: (BuildContext context) => new Home(),
    Register.routeName: (BuildContext context) => new Register(),
    MakeOrder.routeName: (BuildContext context) => new MakeOrder(),
    MakeQuantity.routeName: (BuildContext context) => new MakeQuantity(),
    ConfirmOrder.routeName: (BuildContext context) => new ConfirmOrder(),
    Ordini.routeName: (BuildContext context) => new Ordini(),
    SettingsForm.routeName: (BuildContext context) => new SettingsForm(),
    ManageUtenti.routeName: (BuildContext context) => new ManageUtenti(),

    ///TODO: togliere utente ShowGrid
    SelectUtente.routeName: (BuildContext context) => new SelectUtente(),

    Deliveries.routeName: (BuildContext context) => new Deliveries(),

  };

  /// Widget root dell'applicazione
  /// StreamBuilder che in caso di accesso cambia interfaccia
  //TODO: Spegare come funziona questo StreamBuilder
  @override



  Widget build(BuildContext context) {

    return Container(
    child: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {





          if(snapshot.hasData) {
            return new MediaQuery(
                data: new MediaQueryData(),
                child: new MaterialApp(
                    home: new Home(),
                    routes: routes,
                )
            );
          }
          else {
            return new MediaQuery(
                data: new MediaQueryData(),
                child: new MaterialApp(
                    home: new Authenticate(),
                )
            );
          }
        },
      ),
  );
  }
}