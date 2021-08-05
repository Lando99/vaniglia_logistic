import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/services/database.dart';
import 'package:vaniglia_logistic/shared/makeDrawer.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import 'package:intl/intl.dart';
import 'package:vaniglia_logistic/models/Item.dart';

import '../../constants.dart' as Constants;


class Ordini extends StatefulWidget {
  static const String routeName = "/Ordini";

  @override
  _OrdiniState createState() => _OrdiniState();

}


class _OrdiniState extends State<Ordini> {

  @override
  Widget build(BuildContext context) {


    // Metodo che restituiesce una lista di Items construita dalla lista di ordini letta dal data base e selezionata in base allo stato passato come parametro
    // La lista di Items viene ritoranto in modo decrescente rispetto alla data di consegna
    List<Item> getOrdiniFromState(List<Ordine> ordini, String stato){
      List<Ordine> aux = [];
      List<Item> items = [];

      /*
      if(Routes.utente.ruolo != "admin"){
        ordini.removeWhere((element) => element.utente != "Giotto");

      }
      
       */
      
      for(int i = 0; i<ordini.length;i++){
        switch(stato) {
          case "elaborazione": {
            ordini[i].stato == stato ? aux.add(ordini[i]) : null;
          }
          break;
          case "consegnato": {
            ordini[i].stato == stato ? aux.add(ordini[i]) : null;
          }
          break;
          
        }

      }



      aux.sort((a, b) => b.dateConsegna.compareTo(a.dateConsegna));
      items = generateItems(aux, context);
      
      return items;
    }

    


    return StreamProvider<List<Ordine>>.value(
      value: DatabaseService().ordiniStream,
        initialData: [],
      builder: (context, snapshot) {


        return  DefaultTabController(

            length: 3,
            child: Scaffold(

              backgroundColor: Constants.lightBrown,
              appBar: AppBar(
                  backgroundColor: Constants.darkBrown,
                  elevation: 0.0,
                  title: Text('Ordini'),
                  bottom: TabBar(
                    tabs: [
                      Tab(icon: Text("elaborazione")),
                      Tab(icon: Text("consegnati")),
                      Tab(icon: Text("tutti")),
                    ],
                  ),
              ),
              drawer: MakeDrawer(),


              body: TabBarView(
                children: [
                  ListaOrdini(parent: this, elaborazione: getOrdiniFromState(Provider.of<List<Ordine>>(context), "elaborazione"), consegnati: null, ),
                  ListaOrdini(parent: this, elaborazione: null, consegnati: getOrdiniFromState(Provider.of<List<Ordine>>(context), "consegnato"), ),
                  ListaOrdini(parent: this, elaborazione: getOrdiniFromState(Provider.of<List<Ordine>>(context), "elaborazione"), consegnati: getOrdiniFromState(Provider.of<List<Ordine>>(context), "consegnato"), ),
                ],
              ),
            ),
          );
      }
    );
  }
}

class ListaOrdini extends StatefulWidget {

  _OrdiniState parent;
  List<Item> elaborazione;
  List<Item> consegnati ;


  ListaOrdini({this.parent, this.elaborazione, this.consegnati});

  @override

  _ListaOrdiniState createState() => _ListaOrdiniState();
}

class _ListaOrdiniState extends State<ListaOrdini> {

  @override
  Widget build(BuildContext context) {



    // List view in cui vengono visualizzati i prodotti in elaborazione
    ListView List_Elaborazione = ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        widget.elaborazione != null?
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ExpansionPanelList(

              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  widget.elaborazione[index].isExpanded = !widget.elaborazione[index].isExpanded;
                });
              },
              children: widget.elaborazione.map((Item item) {
                return ExpansionPanel(
                  backgroundColor: item.color,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                        tileColor: item.color,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Icon(Icons.autorenew_outlined, color: Colors.white, ),
                        ),
                        title: item.headerValue
                    );
                  },
                  isExpanded: item.isExpanded,
                  body: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: item.expandedValue,
                  ),
                );
              }).toList(),
            ),
          ) : null,
      ],
    );

    // List view in cui vengono rappresentati i prodotti gia' consegnati
    ListView List_Consegnati = ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        widget.consegnati != null?
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  widget.consegnati[index].isExpanded = !widget.consegnati[index].isExpanded;
                });
              },
              children: widget.consegnati.map((Item item) {



                return ExpansionPanel(
                  backgroundColor: item.color,
                  headerBuilder: (BuildContext context, bool isExpanded) {

                    return  ListTile(
                        tileColor: item.color,
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Icon(Icons.bookmark_border,color: Constants.lightBrown,),
                        ),
                        title: item.headerValue,
                      ///TODO: Implementare onLongPress per fare l'eliminazione

                    );


                    },
                  isExpanded: item.isExpanded,
                  body: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: item.expandedValue,
                  ),
                );
              }).toList(),
            ),
          ) : null,
      ],
    );









    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          widget.elaborazione != null ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("Elaborazione", style: TextStyle(color: Constants.sand, fontSize: 30),)),
          ): Padding(padding: const EdgeInsets.all(0.0), child: Text(""),),

         widget.elaborazione != null ?
           widget.elaborazione.length == 0 ? Padding(
             padding: const EdgeInsets.all(8.0),
             child: Center(
                 child: Text("nussun ordine", style: TextStyle(color: Colors.grey, fontSize: 22),)),
           ) : Padding(padding: const EdgeInsets.all(0.0), child: Text(""),)
         : Padding(padding: const EdgeInsets.all(0.0), child: Text(""),),





          widget.elaborazione == null ?
            Padding(padding: const EdgeInsets.all(0.0), child: Text(""),)
          : List_Elaborazione,


          widget.consegnati != null ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("Consegnati", style: TextStyle(color: Constants.sand, fontSize: 30),)),
          ): Padding(padding: const EdgeInsets.all(0.0), child: Text(""),),

          widget.consegnati != null ?
          widget.consegnati.length == 0 ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("nussun ordine", style: TextStyle(color: Colors.grey, fontSize: 22),)),
          ) : Padding(padding: const EdgeInsets.all(0.0), child: Text(""),)
              : Padding(padding: const EdgeInsets.all(0.0), child: Text(""),),




          widget.consegnati == null?
            Padding(padding: const EdgeInsets.all(0.0), child: Text(""),)
          : List_Consegnati,




       ],
       ),
    );

  }
}





// generatore di Item per la prova
List<Item> generateItems(List<Ordine> ordini, BuildContext context) {

  final AuthService _auth = AuthService();

  return List<Item>.generate(ordini.length, (int index) {
    return Item(
      headerValue:
      Container(
        padding: EdgeInsets.all(20),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Prima colonna
            Column(
              children: [
                Text(
                  ordini[index].utente,
                  textAlign: TextAlign.left,
                  style:  TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  ordini[index].date.day.toString() + "/"+ ordini[index].date.month.toString() + "  "+ordini[index].date.hour.toString() + ":"+ DateFormat('mm').format(ordini[index].date),
                  textAlign: TextAlign.right,
                  style:  TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),

              ],
            ),
            //Seconda colonna
            Column(

              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: (){



                      // Eliminazione dell'ordine
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Eliminare ordine'),
                          content: const Text("Sei sicuro di volere eliminare l'ordine? \nL'operazione è irreversibile"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ANNULLA'),
                            ),
                            TextButton(
                              onPressed: ()
                                  {
                                    DatabaseService(uid: _auth.getUid()).eliminaOrdine(ordini[index].id);
                                    Navigator.pop(context);
                                  },
                              child: const Text('ELIMINA'),
                            ),
                          ],
                        ),
                      );


                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),


      expandedValue: Padding(
          padding: EdgeInsets.all(0.0),
          child: Column(
              children: List.generate(ordini[index].prodotti_quantita.length, (indexP) {
                return  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fastfood_outlined),

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                              ordini[index].prodotti_quantita[indexP].p.nome ,
                          ),
                        ),
                      ],
                    ),
                    Text(
                        ordini[index].prodotti_quantita[indexP].qta.toString() + " Kg"
                    )
                  ],
                );
              })
          )
      ),

      isExpanded: false,
      color: ordini[index].stato == "elaborazione" ? Constants.sand : Constants.blue
    );
  });
}




