import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';
import 'package:vaniglia_logistic/screen/services/auth.dart';
import 'package:vaniglia_logistic/screen/services/database.dart';
import 'package:vaniglia_logistic/shared/makeDrawer.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import 'package:intl/intl.dart';
import '../../constants.dart' as Constants;

class Ordini extends StatefulWidget {
  static const String routeName = "/Ordini";

  @override
  _OrdiniState createState() => _OrdiniState();
}

final AuthService _auth = AuthService();

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
      items = generateItems(aux);
      
      return items;
    }

    


    return StreamProvider<List<Ordine>>.value(
      value: DatabaseService().ordiniStream,
        initialData: [],
      builder: (context, snapshot) {

        return Scaffold(
          backgroundColor: Constants.lightBrown,
          appBar: AppBar(
              backgroundColor: Constants.darkBrown,
              elevation: 0.0,
              title: Text("ordini"),
          ),
          drawer: MakeDrawer(Routes.utente),


          body : ListaOrdini(parent: this, elaborazione: getOrdiniFromState(Provider.of<List<Ordine>>(context), "elaborazione"), items: getOrdiniFromState(Provider.of<List<Ordine>>(context), "consegnato"), ),


        );



      }
    );
  }
}

class ListaOrdini extends StatefulWidget {

  _OrdiniState parent;
  List<Item> elaborazione;
  List<Item> items ;


  ListaOrdini({this.parent, this.elaborazione, this.items});

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
                      leading: Icon(Icons.autorenew_outlined, color: Colors.white,),
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
        ),
      ],
    );

    // List view in cui vengono rappresentati i prodotti gia' consegnati
    ListView List_Criteria = ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.items[index].isExpanded = !widget.items[index].isExpanded;
              });
            },
            children: widget.items.map((Item item) {



              return ExpansionPanel(
                backgroundColor: item.color,
                headerBuilder: (BuildContext context, bool isExpanded) {

                  return  ListTile(
                      tileColor: item.color,
                      leading: Icon(Icons.bookmark_border,color: Constants.lightBrown,),
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
        ),
      ],
    );






    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         widget.elaborazione.length != 0 ? Padding(
           padding: const EdgeInsets.all(8.0),
           child: Center(
               child: Text("Elaborazione", style: TextStyle(color: Constants.sand, fontSize: 30),)),
         ) : Padding(padding: const EdgeInsets.all(0.0), child: Text(""),),
          Container(
             child: List_Elaborazione),

         widget.items.length != 0 ? Padding(
           padding: const EdgeInsets.all(8.0),
           child: Center(child: Text("Consegnati", style: TextStyle(color: Constants.darkBrown, fontSize: 30),)),
         ) : Padding(padding: const EdgeInsets.all(0.0), child: Text(""),),
         Container(
             child: List_Criteria),



       ],
       ),
    );

  }
}





// Classe di Item
class Item {
  Item({ this.expandedValue, this.headerValue,
    this.isExpanded,this.color
  });

  Widget expandedValue;
  Widget headerValue;
  Color color;
  bool isExpanded;
}

// generatore di Item per la prova
List<Item> generateItems(List<Ordine> ordini) {

  return List<Item>.generate(ordini.length, (int index) {
    return Item(
      headerValue:
          Column(
            children: [

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ordini[index].stato ,
            textAlign: TextAlign.right,
            style:  TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
            ),
          ),




        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ordini[index].date.day.toString() + "/"+ ordini[index].date.month.toString() + "  "+ordini[index].date.hour.toString() + ":"+ DateFormat('mm').format(ordini[index].date),
            textAlign: TextAlign.right,
            style:  TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            ordini[index].dateConsegna.day.toString() + "/"+ ordini[index].dateConsegna.month.toString() + "  "+ordini[index].dateConsegna.hour.toString() + ":"+ DateFormat('mm').format(ordini[index].dateConsegna) ,
            textAlign: TextAlign.right,
            style:  TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      )
          ]),

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
                              ordini[index].prodotti_quantita[indexP].p.nome,
                          ),
                        ),
                      ],
                    ),
                    Text(
                        ordini[index].prodotti_quantita[indexP].qta.toString()
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

