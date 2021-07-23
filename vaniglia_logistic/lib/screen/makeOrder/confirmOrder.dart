import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeQuantity.dart';
import 'package:vaniglia_logistic/screen/makeOrder/selectUtente.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'makeOrder.dart';


import 'package:vaniglia_logistic/constants.dart' as Constants;

class ConfirmOrder extends StatefulWidget {

  static const String routeName = "/ConfirmOrder";

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {


    List<Prodotto_Quantita> lista = [ Prodotto_Quantita(p: Prodotto(nome: "pera"), qta: 2)];
    final ScreenArgumentsArgs argomenti = ModalRoute.of(context).settings.arguments;

    //ScreenArgumentsArgs("Ipercity", lista );



    //final ScreenArgumentsArgs args = ModalRoute.of(context).settings.arguments;

    final String utente = Global.u;

    final List<Prodotto_Quantita> prodotti = argomenti.prodotti;




    return Scaffold(
      backgroundColor: Constants.lightBrown,
      appBar: AppBar(
          backgroundColor: Constants.darkBrown,
          elevation: 0.0,
          title: Text('conferma ordine'),
          leading:  IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () { Navigator.pop(context);
            },
          )
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: prodotti.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Constants.violet,
            child: Center(child: Text('${prodotti[index].toString()}')),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_basket),
        backgroundColor: Constants.red,
        onPressed: () async {

          // Azzeramento dei prodotti precedentementi selezionati
          prodottiScelti.forEach((element1) {
            prodotti_grafici.add(element1);
          });
          prodottiScelti = [];

          dynamic result = await _auth.addOrder(utente, prodotti );
          ///TODO: inserire azioni di controllo in result

          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
    );
  }
}
