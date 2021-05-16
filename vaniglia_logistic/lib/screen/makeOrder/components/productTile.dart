import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeOrder.dart';

import 'package:vaniglia_logistic/constants.dart' as Constants;

// INPUT : p prodotto da rappresentare
// state e' una funzione passata per fare un setState al widget parent
// isSelect rappresenta se e' il prodotto da rappresentare appartiene alla lista dei prodotti
// selezionati oppure tra quelli disponibili

class Product_tile extends StatefulWidget {

  final Prodotto p;
  final Function state;
  bool isSelect;

  Product_tile({this.state, this.p, this.isSelect});

  @override
  _Product_tileState createState() => _Product_tileState();
}

class _Product_tileState extends State<Product_tile> {
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)
        ),
      ),
      color: widget.isSelect ? Constants.blue : Constants.violet,
      elevation: 10,
      child: InkWell(

        splashColor: Constants.lightBrown,
        onTap: () {
          if(widget.isSelect){

            prodottiScelti.add(widget.p);
            prodotti_grafici.removeWhere((element) => element.nome == widget.p.nome);
            widget.state();

          }else{

            prodotti_grafici.add(widget.p);
            prodottiScelti.removeWhere((element) => element.nome == widget.p.nome);
            widget.state();

          }
        },

        child: Container(
          width: 300,
          height: 300,

          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  children: <Widget>[

                    Expanded (child: Image(image: AssetImage('assets/${widget.p.nome}.png'))),
                    Text(widget.p.nome),
                  ]
              )
          ),
        ),
      ),
    );

  }
}