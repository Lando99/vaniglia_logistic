
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeQuantity.dart';


/// Classe che contiene informazioni relativo a un ORDINAZIONE
class Ordine{

  String id;
  String utente = '';

  DateTime date = new DateTime(2000,04,30);
  Map<String, dynamic> list = {'':''} ;
  List<Prodotto_Quantita> prodotti_quantita = [];

  String stato;
  DateTime dateConsegna = new DateTime(2000,04,30);


  Ordine(String id, String utente, Timestamp timestamp,  Map<String, dynamic> map, String stato, Timestamp timestampConsegna) {
    this.utente = utente;
    this.list = list;
    map.forEach((k, v) => prodotti_quantita.add(Prodotto_Quantita(p: Prodotto(nome: k), qta: v)));

    this.date = timestamp.toDate();
    this.stato = stato;
    this.dateConsegna = timestampConsegna.toDate();
    this.id = id;


  }

  String toStringProdottiQuantita() {
    String s = "";
    int index = 0;
    this.prodotti_quantita.forEach((element) {
      s += element.toString();
      if(index < prodotti_quantita.length-1){
        s += "\n";

      }

      index++;

    });

    return s;
  }





}

