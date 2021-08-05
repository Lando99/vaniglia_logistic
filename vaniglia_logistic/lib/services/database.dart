
import 'dart:developer';

import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateUserData(String nome, String ruolo) async {
    return await utenti.doc(uid).set({
        'email': nome,
        'ruolo': ruolo,
      });

  }

  Future<void> updateStatusOrder(String id, String stato) async {
    return await ordini.doc(id).update({
      'stato': stato,
    });
  }


  // Scrittura degli ordini sul database
  Future<void> updateOrdiniData(String utente, DateTime date, List<Prodotto_Quantita> list) async {

    // generazione manuale dell'id per 'ordine
    var uuid = Uuid();
    String id = uuid.v4();

    var docData = {
      'id' : id,
      'utente' : utente,
      'date' : date,
      'stato' : "elaborazione",
      'prodotti' : null,
      'dateConsegna' : null
    };




    var map1 = Map.fromIterable(list, key: (e) => e.p.nome, value: (e) => e.qta);

    docData['prodotti'] = map1;

    DateTime now = new DateTime.now();
    DateTime dateConsegna = new DateTime(now.year, now.month, now.day, now.hour, now.minute);


    int martedi= 1, venerdi = 4;

    switch(now.weekday) {
      case 1: {
        now = now.add(Duration(days: 1));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;

      case 2: {
        now = now.add(Duration(days: 3));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;

      case 3: {
        now = now.add(Duration(days: 2));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;

      case 4: {
        now = now.add(Duration(days: 1));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;

      case 5: {
        now = now.add(Duration(days: 4));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;

      case 6: {
        now = now.add(Duration(days: 3));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;

      case 7: {
        now = now.add(Duration(days: 2));
        dateConsegna = new DateTime(now.year, now.month, now.day, 9, 00);
      }
      break;
    }

    docData['dateConsegna'] = dateConsegna;
    return await ordini.doc(id).set(docData);

  }

  /// *** METODI SUGLI UTENTI

  // ** Lettura utentti **
  List<Utente> _utentiFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Utente(
        email: doc.data()['email'] ?? '',
        ruolo: doc.data()['ruolo'] ?? '',

      );
    }).toList();
  }
  // Stream utenti
  Stream<List<Utente>> get utentiStream{
    return utenti.snapshots()
    .map(_utentiFromSnapshot);
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





  Utente get utenteCorrenteData{
    utenti.doc("qcacMKpWLiP8KfoHNcfdP5CK6Uf2").get().then((value){

      return Utente(
          uid:"qcacMKpWLiP8KfoHNcfdP5CK6Uf2",
          email: value.data()['email'] ?? '',
          ruolo: value.data()['ruolo'] ?? '',
      );

    });

  }

  Future<Utente> utenteData(String id) async{
    return await utenti.doc(id).get().then((value) {
      return Utente(
        uid: id,
        email: value.data()['email'] ?? '',
        ruolo: value.data()['ruolo'] ?? '',
      );

    });

  }



  // ** Metodi tabella calendario **


  //Meteodo che ritorna i dati statici
  Future<List<Evento>> eventiStatici (int mese, int anno) async  {
    return await calendario.where('__name__' , isEqualTo : mese.toString()+"_"+anno.toString()).snapshots().map(_eventiCalendarioFromSnapshot).first;

  }

  //update eventi
  Future<void> updateEventi(Evento e) async {


    var date = new DateTime.fromMicrosecondsSinceEpoch(e.date.microsecondsSinceEpoch);
    int mese = date.month, anno = date.year;

    List<Evento> eventi = await eventiStatici(mese, anno);

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

    List<Timestamp> data = List.from(snapshot.docs.first['consegne']);


    
    
    for(int i = 0; i < data.length; i ++){
      Evento aux = Evento(id: "consegna "+ i.toString(),date: data.elementAt(i));
      eventi.add(aux);

    }

    return eventi.toList();

  }
  // Stream eventi calendario
 Stream<List<Evento>> eventiCalendarioStream(int anno, int mese){

    return calendario.where('__name__' , isEqualTo : mese.toString()+"_"+anno.toString()).snapshots().map(_eventiCalendarioFromSnapshot);
   
  }

}







