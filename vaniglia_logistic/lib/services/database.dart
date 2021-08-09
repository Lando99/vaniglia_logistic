
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaniglia_logistic/models/Prodotto_Quantita.dart';
import 'package:vaniglia_logistic/models/evento.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeQuantity.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  /// Tabelle database
  final CollectionReference utenti = FirebaseFirestore.instance.collection('utenti');
  final CollectionReference ordini = FirebaseFirestore.instance.collection('ordini');
  final CollectionReference calendario = FirebaseFirestore.instance.collection('calendario');



  //Metodi di UPDATE

  Future<void> updateUserData(String nome, String ruolo, String societa) async {
    return await utenti.doc(uid).set({
        'email': nome,
        'ruolo': ruolo,
        'società`' : societa
      });

  }

  Future<void> updateStatusOrder(String id, String stato) async {
    return await ordini.doc(id).update({
      'stato': stato,
    });
  }


  // Scrittura degli ordini sul database
  Future<void> updateOrdiniData(String utente, DateTime date, List<Prodotto_Quantita> list, String societa) async {

    // generazione manuale dell'id per 'ordine
    var uuid = Uuid();
    String id = uuid.v4();

    var docData = {
      'id' : id,
      'utente' : utente,
      'date' : date,
      'stato' : "elaborazione",
      'prodotti' : null,
      'dateConsegna' : null,
      'società': societa
    };




    var map1 = Map.fromIterable(list, key: (e) => e.p.nome, value: (e) => e.qta);

    docData['prodotti'] = map1;

    DateTime now = new DateTime.now();

    //vedo se c'è in questo mese una cosegna disponibile
    List<Evento> eventi = await eventiStatici(now.month, now.year);


    for(int i = 0; i<eventi.length; i++){
      if(eventi.elementAt(i).date.compareTo(Timestamp.now()) == -1){
        eventi.removeAt(i);
      }
    }
    Evento min;
    if(eventi.length == 0 ){
      //vai al prossimo mese
      eventi = await eventiStatici(now.month+1, now.year).catchError((error, stackTrace) {
        print("inner: $error");
        // although `throw SecondError()` has the same effect.
        return <Evento> [];
      });
      print("ok2");
      print("eventi "+eventi.toString());


    }

    if(eventi.length != 0){

      eventi.sort((a, b) => a.date.compareTo(b.date));
      min = eventi.first;

      DateTime dateConsegna = min.date.toDate();




      docData['dateConsegna'] = dateConsegna;
      return await ordini.doc(id).set(docData);
    }else{
      //return <Evento> [];
      return Future.error("This is the error", StackTrace.fromString("This is its trace"));
    }

  }

  /// *** METODI SUGLI UTENTI

  // ** Lettura utentti **
  List<Utente> _utentiFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Utente(
        email: doc.data()['email'] ?? '',
        ruolo: doc.data()['ruolo'] ?? '',
        societa: doc.data()['società'] ?? ''
      );
    }).toList();
  }
  // Stream utenti
  Stream<List<Utente>> get utentiStream{
    return utenti.snapshots()
    .map(_utentiFromSnapshot);
  }

  Future<List<Utente>> utentiFuture () async  {
    return await utentiStream.first;

  }


  /// *** METODI PER LA GESTIONE ORDINI ***

  // ** Lettura ordini **
  List<Ordine> _ordiniFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){

      Ordine aux;

      aux =  Ordine(
        doc.data()['id'] ?? '',
        doc.data()['utente'] ?? '',
        doc.data()['date'] ?? null,
        doc.data()['prodotti'] ?? null,
        doc.data()['stato'] ?? '',
        doc.data()['dateConsegna'] ?? null,
        doc.data()['società'] ?? ''

      );

      return aux;
    }).toList();
  }
  // Stream ordini
  Stream<List<Ordine>> get ordiniStream{
    return ordini.snapshots()
        .map(_ordiniFromSnapshot);
  }

  //Eliminare un ordine
  Future<void> eliminaOrdine(String id) {
    return ordini
        .doc(id)
        .delete()
        .then((value) => print("ordine eliminato"))
        .catchError((error) => print("eliminazione ordine fallita: $error"));


  }
/*
  // Analisi degli ordini
  Future<void> analisiOrdini(String utente, String periodo) {

    DateTime 
    Timestamp date = Timestamp.fromDate(date)
    int mese = date.month, anno = date.year;
    
    if(utente == "tutti"){
      return ordini.where("date", isGreaterThan:  )
      
    }


  }


 */
  // ** Metodi tabella calendario **


  //Meteodo che ritorna i dati statici
  Future<List<Evento>> eventiStatici (int mese, int anno) async  {
    return await calendario.where('__name__' , isEqualTo : mese.toString()+"_"+anno.toString()).snapshots().map(_eventiCalendarioFromSnapshot)
        .first.catchError((e) {
      return Future.error("Nessuna consegna programmata");
    });


    //.onError((error, stackTrace) {print("ciao"); return [];});

  }

  //update eventi
  Future<void> updateEventi(Evento e) async {


    var date = new DateTime.fromMicrosecondsSinceEpoch(e.date.microsecondsSinceEpoch);
    int mese = date.month, anno = date.year;

    List<Evento> eventi = await eventiStatici(mese, anno);
    if(eventi.length==0){

      String id = mese.toString() + "_" + anno.toString();

      calendario.doc(id).set({
        'consegne': [],
      }).then((value) => print("nuovo mese di consegne aggiuto"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    eventi.add(e);


    var arr = new List(eventi.length);// creates an empty array of length 5
    // assigning values to all the indices
    for(int i = 0; i < eventi.length; i++){
      arr[i] = eventi.elementAt(i).date;
    }


    return calendario
        .doc(mese.toString() + "_" + anno.toString())
        .update({'consegne': arr})
        .then((value) => null )
        .catchError((error) => print("Failed to update evento: $error"));
  }

  // Lettura degli eventi
  List<Evento> _eventiCalendarioFromSnapshot(QuerySnapshot snapshot){

    print("Read eventi");

    List<Evento> eventi = <Evento> [] ;


    if(snapshot.size != 0){
      List<Timestamp> data = List.from(snapshot.docs.first['consegne']);


      for(int i = 0; i < data.length; i ++){
        Evento aux = Evento(id: "consegna "+ i.toString(),date: data.elementAt(i));
        eventi.add(aux);

      }

      return eventi.toList();

    }else{
      throw("nessuna consegna programmata");
    }


  }
  // Stream eventi calendario
 Stream<List<Evento>> eventiCalendarioStream(int anno, int mese){

    return calendario.where('__name__' , isEqualTo : mese.toString()+"_"+anno.toString()).snapshots().map(_eventiCalendarioFromSnapshot);
   
  }
  
  

}




