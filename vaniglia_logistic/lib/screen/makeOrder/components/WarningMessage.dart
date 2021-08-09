
import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/Prodotto_Quantita.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeOrder.dart';
import 'package:vaniglia_logistic/services/database.dart';

import '../makeQuantity.dart';

class WarningMessage extends StatefulWidget {
  final String order;
  final MakeOrderState parent;
  WarningMessage({this.order, this.parent});
  @override
  _WarningMessageState createState() => _WarningMessageState();
}

class _WarningMessageState extends State<WarningMessage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ordinazione gia\' effettuato'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Ordinazione gia fatta per questo punto vendita'),
            Text("Se si vuole modificare l'ordinazione precedente verrà modificata"),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Modifica'),
          onPressed: () {


            DatabaseService().ordini.where('__name__', isEqualTo: widget.order).get().then((data) {
              setState(() {

                List<Ordine> lista = data.docs.map((doc){

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

                print(lista.first.prodotti_quantita);
                prodottiScelti  = prodottoQuantitaToProdotto(lista.first.prodotti_quantita);
                for(int i = 0; i < prodottiScelti.length; i++){
                  for(int j = 0; j<prodotti_grafici.length;j++){
                    if(prodotti_grafici[j].nome == prodottiScelti[i].nome){
                      prodotti_grafici.removeAt(j);
                      break;
                    }
                  }
                }
                prodotti_quantita = lista.first.prodotti_quantita;
                DatabaseService().eliminaOrdine(lista.first.id);
                widget.parent.setState(() {});



              });

            }).catchError((e) {
              Navigator.pop(context, "an error");
            });





            //prodottiScelti =
            Navigator.of(context).pop();
            ///Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}