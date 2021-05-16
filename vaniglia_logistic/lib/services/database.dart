
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeQuantity.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  /// Tabelle database: utenti
  final CollectionReference utenti = FirebaseFirestore.instance.collection('utenti');
  final CollectionReference ordini = FirebaseFirestore.instance.collection('ordini');



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

  // brew from snapshot
  List<Utente> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Utente(
        email: doc.data()['email'] ?? '',
        ruolo: doc.data()['ruolo'] ?? '',

      );
    }).toList();
  }

  // Stream sul database
  Stream<List<Utente>> get utentiStream{
    return utenti.snapshots()
    .map(_brewListFromSnapshot);
  }


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

  // Stream sul database
  Stream<List<Ordine>> get ordiniStream{
    return ordini.snapshots()
        .map(_ordiniFromSnapshot);
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



}







