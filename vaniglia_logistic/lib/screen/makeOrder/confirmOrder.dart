import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/Prodotto_Quantita.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeQuantity.dart';
import 'package:vaniglia_logistic/screen/makeOrder/selectUtente.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/services/database.dart';
import 'makeOrder.dart';


import 'package:vaniglia_logistic/constants.dart' as Constants;

class ConfirmOrder extends StatefulWidget {

  static const String routeName = "/ConfirmOrder";

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {

  final AuthService _auth = AuthService();
  var societa = '';

  @override
  void initState() {
    super.initState();

    DatabaseService().utenti.where('email', isEqualTo: Global.u + '@gmail.com').get().then((data) {
      setState(() {
        List l = data.docs.map((e) => e.data()['società']).toList();
        societa = l.first.toString();
        print(societa);

      });

    }).catchError((e) {
      Navigator.pop(context, "an error");
    });



  }

  @override
  Widget build(BuildContext context) {


    final ScreenArgumentsArgs argomenti = ModalRoute.of(context).settings.arguments;



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
      body: Column(
        children: [
          Text("La merce verrà consegnata alla prossima data disponibile"),
          Expanded(
            child: SizedBox(
              height: 200.0,
              child: ListView.separated(
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
            ),
          )
        ],

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

          dynamic result = await _auth.addOrder(utente, prodotti, societa, context );
          if(result.toString() == "AlertDialog - nessun evento programmato"){
            print("dentro");
            showDialog(
                barrierDismissible: true,//tapping outside dialog will close the dialog if set 'true'
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text('Nessuna consegna programmata'),
                    content: const Text("Contatta l'amministratore per far aggiungere nuovi eventi di consegna"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
            );
          }else{
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }

          //
        },
      ),
    );
  }
}
