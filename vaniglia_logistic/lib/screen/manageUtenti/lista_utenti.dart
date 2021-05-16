import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/manageUtenti/utente_tile.dart';

class ListaUtenti extends StatefulWidget {
  @override
  _ListaUtentiState createState() => _ListaUtentiState();
}

class _ListaUtentiState extends State<ListaUtenti> {
  @override
  Widget build(BuildContext context) {
    
    final utenti = Provider.of<List<Utente>>(context);


    return ListView.builder(
      itemBuilder: (context, index){
        return UtenteTile(utente: utenti[index]);
      },
      itemCount: utenti.length,
    );
  }
}
