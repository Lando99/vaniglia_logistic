import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/screenArguments.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import 'package:vaniglia_logistic/constants.dart' as Constants;


List<int> numbers = [1,2,3,4,5,6,7,8,9];

/**
 * #View per selezionare le quantita' di merce che vogliamo ordinare
 *
 * */
class MakeQuantity extends StatefulWidget {

  static const String routeName = "/MakeQuantity";

  @override
  _MakeQuantityState createState() => _MakeQuantityState();
}

List<Prodotto_Quantita> prodotti_quantita;

class _MakeQuantityState extends State<MakeQuantity> {
  @override
  Widget build(BuildContext context) {

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    final String utente = args.utente;
    final List<Prodotto> prodotti = args.prodotti;


    prodotti_quantita = copyList(prodotti);


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
        child: Icon(Icons.navigate_next_rounded),
        backgroundColor: Constants.red,
        onPressed: (){
          Navigator.pushNamed(
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

  int dropdownValue = 1;

  @override
  Widget build(BuildContext context) {
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
                   child: FloatingActionButton(
                    onPressed: (){
                      if(dropdownValue < 9){
                        setState(() {
                          dropdownValue = dropdownValue + 1;
                          prodotti_quantita.elementAt(widget.index).qta = dropdownValue;
                        });
                      }

                    },
                    child: new Icon(Icons.add, color: Colors.black,),
                    backgroundColor: Colors.white,),
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
                child: DropdownButton<int>(
                  value: dropdownValue,
                  onChanged: (int newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      prodotti_quantita.elementAt(widget.index).qta = dropdownValue;
                    });
                  },
                  items: numbers
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),

                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: FloatingActionButton(
                    onPressed: (){
                      if(dropdownValue > 1){
                        setState(() {
                          dropdownValue = dropdownValue - 1;
                          prodotti_quantita.elementAt(widget.index).qta = dropdownValue;
                        });
                      }
                    },
                    child: new Icon(Icons.remove, color: Colors.black,),
                    backgroundColor: Colors.white,),
                ),



          ]),


    ),

    );
  }
}

// Classe che mette in relazione il prodotto e la sua quantia' durante la generazione di un ordine
class Prodotto_Quantita{

  final Prodotto p;
  int qta;

  Prodotto_Quantita ({this.p,this.qta = 0});

  @override
  String toString() {
    return " ${qta} : ${p.nome}";
  }
}

//costruttore di default per la lista dei prodotti
List<Prodotto_Quantita> copyList( List<Prodotto> prodotti){
  List<Prodotto_Quantita> aux = [];
  for(int i = 0; i<prodotti.length; i++){
    aux.add(Prodotto_Quantita(p: prodotti[i], qta: 1));
  }
  return aux;

}
