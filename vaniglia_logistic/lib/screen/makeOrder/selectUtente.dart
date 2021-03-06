import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/services/database.dart';
import 'package:vaniglia_logistic/shared/routes.dart';

import 'package:vaniglia_logistic/constants.dart' as Constants;
import 'package:vaniglia_logistic/shared/globals.dart' as globals;


class Global {
  static String u = "";
}


List<String> accounts  = ["seleziona    "];


class SelectUtente extends StatefulWidget {

  static const String routeName = "/selectUtente";

  @override
  _SelectUtenteState createState() => _SelectUtenteState();
}

class _SelectUtenteState extends State<SelectUtente> {


  String dropdownValue = accounts[0];
  final snackBarError = SnackBar(content: Text('Seleziona utente!'));



  @override
  void initState() {
    super.initState();

    accounts = ["seleziona    "];
    DatabaseService().utenti.where('ruolo', isEqualTo: 'standart').get().then((data) {
      setState(() {
        List list = data.docs.map((e) => e.data()['email']).toList();
        
        
        for(int i = 0; i < list.length; i++){
          accounts.add(list.elementAt(i).toString().split('@').first);
        }
      });



    }).catchError((e) {
      Navigator.pop(context, "an error");
    });




    dropdownValue = accounts[0];
    Global.u = accounts[0];
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightBrown,
      appBar: AppBar(
          backgroundColor: Constants.darkBrown,
          elevation: 0.0,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                  child: Text('annulla',
                    style: TextStyle(fontSize: 15),
                  ),
                ),

              ),
              Center(
                child: Text('Ordine ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(''),
                ),
              ),

            ],
          ),
          leading:
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () { Navigator.pop(context); },
          )
      ),
      body: Padding(
        padding: const EdgeInsets.only( left: 15.0),
        child: Row(
          children: [
            Text(" Utente:  ",
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(

              value: dropdownValue,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                  Global.u = newValue;

                });
              },
              items: accounts
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnSelectUser",
        onPressed: () {
          dropdownValue = accounts[0];

          if(Global.u != "Seleziona"){
            Navigator.pushNamed(
                context, Routes.makeOrder
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(snackBarError);
          }

        },
        child: const Icon(Icons.navigate_next_rounded),
        backgroundColor: Constants.red,
      )
    );
  }
}
