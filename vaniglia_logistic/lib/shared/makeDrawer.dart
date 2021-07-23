import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';
import 'package:vaniglia_logistic/screen/impostazioni/preference.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import '../../constants.dart' as Constants;


/**
 * #Drawer per l'applicazione
 * Mostra un elenco delle schermate a cui si puo' accedere
 * Viene passato un parametro [user] per rendere visibili determinate schermate a seconda della tipologia di permessi
 * che ha quel utente
 * */
class MakeDrawer extends StatelessWidget  {

  final Utente _user;
  MakeDrawer(this._user);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Constants.sand,
                  Constants.mediumBrown
                ])
            ),
            child: Column(
              children: [
                Icon(Icons.person, size: 50,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _user.email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _user.ruolo,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

          ),
          Container(
            child: (_user.ruolo == "admin") ?
            ListTile(
              leading: Icon(Icons.home_filled),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.popUntil(context, ModalRoute.withName('/'));

              },
            ) : null,
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Ordini'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.ordini);
            },
          ),


          Container(
            child: (_user.ruolo == "admin") ?
            ListTile(
              //TODO: Gestire MakeOrder per l'admin
              leading: Icon(Icons.pending_actions),
              title: Text('makeOrder'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.selectUtente);
              },
            ) :
            ListTile(
              //TODO: Gestire MakeOrder per l'utente standart in modo corretto EMAIL!!UTENTE
              leading: Icon(Icons.pending_actions),
              title: Text('makeOrder'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context,
                    Routes.makeOrder,
                    arguments: _user.email,
                );
              },
            )

          ),


          Container(
            child: (_user.ruolo == "admin") ?
            ListTile(
              //TODO: Gestire deliveries per l'admin
              leading: Icon(Icons.wallet_travel),
              title: Text('Consegne'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.deliveries);

              },
            ) : null,
          ),
          Container(
              child:(_user.ruolo == "admin") ?
              ListTile(
                leading: Icon(Icons.people_alt_outlined),
                title: Text('Utenti'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, Routes.manageUtenti);
                },
              ) : null
          ),
          Container(
            child: (_user.ruolo == "admin") ?
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Impostazioni'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, PageTransition(duration: Duration(milliseconds: 200),type: PageTransitionType.bottomToTop, child: SettingsForm()));
              },

            ) : null,
          ),
          Divider(),
          ListTile(
            title: Text('0.0.5'),
          ),
        ],
      ),
    );
  }
}