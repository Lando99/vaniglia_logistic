

import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/Prodotto_Quantita.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeOrder.dart';
import 'package:vaniglia_logistic/screen/makeOrder/screenArguments.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import 'package:vaniglia_logistic/constants.dart' as Constants;

import 'confirmOrder.dart';



Map<String, double> quantitaMap = {'1/4': 0.25, '1/2': 0.5, '1': 1};
/**
 * #View per selezionare le quantita' di merce che vogliamo ordinare
 *
 * */
class MakeQuantity extends StatefulWidget {

  static const String routeName = "/MakeQuantity";

  @override
  _MakeQuantityState createState() => _MakeQuantityState();
}

List<Prodotto_Quantita> prodotti_quantita = [];

class _MakeQuantityState extends State<MakeQuantity> {
  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    final String utente = args.utente;
    final List<Prodotto> prodotti = args.prodotti;


    if(prodotti_quantita.length == 0){
      prodotti_quantita = copyList(prodotti);
    }
    if(prodotti_quantita.length < prodotti.length){
      for(int i = 0; i<prodotti.length; i++){
        bool trovato = false;
        for(int j = 0; j<prodotti_quantita.length; j++){
          if(prodotti_quantita[j].p.nome == prodotti[i].nome)
            trovato = true;

        }
        if(trovato == false){
          prodotti_quantita.add(Prodotto_Quantita(p: prodotti[i], qta: 1));
        }
      }
    }



    return Scaffold(
      backgroundColor: Constants.lightBrown,
      appBar: AppBar(
          backgroundColor: Constants.darkBrown,
          elevation: 0.0,
          title: Text('seleziona quantita'),
          leading:  IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () { Navigator.pop(context);
            },
          )
      ),
      body: CustomScrollView(

        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return  CardMakeQuanity(parent: this, p: prodotti[index], index: index,);
                },
                childCount: prodotti.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnMakeQuantity",
        child: Icon(Icons.navigate_next_rounded),
        backgroundColor: Constants.red,
        onPressed: (){


          Navigator.pushReplacementNamed(
              context,
              Routes.confirmOrder,
              arguments: ScreenArgumentsArgs(utente, prodotti_quantita),
          );


        },
      ),
    );
  }
}



class ScreenArgumentsArgs {
  final String utente;
  final List<Prodotto_Quantita> prodotti;

  ScreenArgumentsArgs(this.utente, this.prodotti);
}


class CardMakeQuanity extends StatefulWidget {
   Prodotto p;
  _MakeQuantityState parent;
  int index;


  CardMakeQuanity({this.parent,this.p, this.index});

  @override
  _CardMakeQuanityState createState() => _CardMakeQuanityState();
}

class _CardMakeQuanityState extends State<CardMakeQuanity> {



  @override
  Widget build(BuildContext context) {
    double dropdownValue = prodotti_quantita.elementAt(widget.index).qta;

    return Card(
      color: Constants.lightGreen,
      child: ListTile(
          leading: Icon(Icons.fastfood, color: Colors.white),
          title: Text(widget.p.nome,
          style: TextStyle(color: Colors.white ) ,),
          subtitle: Text(""),
          trailing:
          Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.only(left: 15, right: 15),
                   child: ElevatedButton(
                    onPressed: (){
                      if(dropdownValue < 9){
                        setState(() {
                          dropdownValue = dropdownValue + 1;
                          prodotti_quantita.elementAt(widget.index).qta = dropdownValue;
                        });
                      }

                    },
                    child: new Icon(Icons.add, color: Colors.black,),
                   ),
                 ),



                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: new BoxDecoration(

                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft:  const  Radius.circular(5.0),
                        topRight: const  Radius.circular(5.0),
                        bottomLeft: const  Radius.circular(5.0),
                        bottomRight: const  Radius.circular(5.0)
                    ),
                  ),
                  child: DropdownButton<double>(
                    value: dropdownValue,
                    onChanged: (double newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        prodotti_quantita.elementAt(widget.index).qta = dropdownValue;
                      });
                      },
                    items: quantitaMap
                        .map((description, value){
                          return MapEntry(description,
                              DropdownMenuItem<double>(
                                value: value,
                                child: Text(description),
                              ));
                        }).values.toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: ElevatedButton(
                    onPressed: (){
                      if(dropdownValue > 1){
                        setState(() {
                          dropdownValue = dropdownValue - 1;
                          prodotti_quantita.elementAt(widget.index).qta = dropdownValue;
                        });
                      }
                    },
                    child: new Icon(Icons.remove, color: Colors.black,),
                    ),
                ),



          ]),


    ),

    );
  }
}

