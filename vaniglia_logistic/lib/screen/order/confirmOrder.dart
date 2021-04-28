import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';
import 'package:vaniglia_logistic/screen/order/makeQuantity.dart';
import 'package:vaniglia_logistic/screen/services/auth.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';
import '../../constants.dart' as Constants;
import 'makeOrder.dart';


class ConfirmOrder extends StatefulWidget {

  static const String routeName = "/ConfirmOrder";

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {



    final ScreenArgumentsArgs args = ModalRoute.of(context).settings.arguments;

    final String utente = args.utente;

    final List<Prodotto_Quantita> prodotti = args.prodotti;




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

          dynamic result = await _auth.addOrder(utente, prodotti);
          ///TODO: inserire azioni di controllo in result

          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
      ),
    );
  }
}
