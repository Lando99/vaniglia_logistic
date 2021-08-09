
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:vaniglia_logistic/models/ordine.dart';

import '../../constants.dart' as Constants;

class Deliveries extends StatefulWidget {
  static const String routeName = "/Deliveries";
  @override
  _DeliveriesState createState() => _DeliveriesState();
}
int indexCurrent = 0;

class _DeliveriesState extends State<Deliveries> {

  List<Ordine> ordini = [
    Ordine( "001", "Brentelle", Timestamp.now(), {"banana" : 2}, "stato", Timestamp.now(), 'Vaniglia'),
    Ordine( "001", "Ipercity", Timestamp.now(), {"banana" : 2}, "stato", Timestamp.now(), 'Cucchiaio del re'),
    Ordine( "001", "Giotto", Timestamp.now(), {"banana" : 2, "mela" : 7}, "stato", Timestamp.now(), 'Copernico')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mediumBrown,
      appBar: AppBar(
        title: Text('Consegne'),
        backgroundColor: Constants.darkBrown,
        elevation: 0.0,

      ),
      body: ListView.builder(
        itemBuilder: (context, index){
          return TimeLine_Tile(ordine: ordini[index], indexTile: index, indexMax: ordini.length, parent: this, );
        },
        itemCount: ordini.length,
      )
    );

  }

}






class TimeLine_Tile extends StatefulWidget {

  final Ordine ordine;
  final int indexTile;
  final int indexMax;
  final _DeliveriesState parent;

  TimeLine_Tile({this.ordine, this.indexTile, this.indexMax, this.parent});

  @override
  _TimeLine_TileState createState() => _TimeLine_TileState();
}

class _TimeLine_TileState extends State<TimeLine_Tile> {
  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      oppositeContents: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.ordine.utente),
      ),
      contents: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(widget.ordine.toStringProdottiQuantita()),
              ),
              widget.indexTile == indexCurrent
                  ? RaisedButton( onPressed: (){
                  setState(() {
                    indexCurrent ++;
                    widget.parent.setState(() {});
                      print(indexCurrent);
                    });
                  }, child: Text("avanti"),)
                  : Padding(padding: EdgeInsets.zero)
            ],
          ),
        ),

      ),
      node: TimelineNode(
        indicator: widget.indexTile == indexCurrent
            ? OutlinedDotIndicator(size: 30, color: Colors.grey, child: Icon(Icons.stream, size: 17,),)
            : widget.indexTile < indexCurrent
              ?  DotIndicator(color: Constants.lightGreen, size: 30, child: Icon(Icons.check),)
              :  OutlinedDotIndicator(size: 30, color: Colors.grey),
        startConnector: widget.indexTile == 0
            ? null
            : widget.indexTile < indexCurrent
              ? SolidLineConnector(color: Constants.lightGreen,)
              : DashedLineConnector(color: Colors.grey,),
        endConnector: widget.indexTile == widget.indexMax-1
            ? null
            : widget.indexTile < indexCurrent
              ? SolidLineConnector(color: Constants.lightGreen,)
              : DashedLineConnector(color: Colors.grey,),

      ),
    );

  }
}


