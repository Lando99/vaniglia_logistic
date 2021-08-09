import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:vaniglia_logistic/models/prodotti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/components/productTile.dart';
import 'package:vaniglia_logistic/screen/makeOrder/screenArguments.dart';
import 'package:vaniglia_logistic/screen/makeOrder/selectUtente.dart';
import 'package:vaniglia_logistic/shared/loading.dart';
import 'package:vaniglia_logistic/shared/routes.dart';
import 'package:vaniglia_logistic/constants.dart' as Constants;
import 'components/WarningMessage.dart';


class MakeOrder extends StatefulWidget {

  static const String routeName = "/MakeOrder";

  final String utenteString;

  MakeOrder({this.utenteString});


  @override
  MakeOrderState createState() => MakeOrderState();
}


List<Prodotto> prodotti_grafici = [
  Prodotto(nome: "carota", ),
  Prodotto(nome: "arancia",),
  Prodotto(nome: "mela", ),
  Prodotto(nome: "pera", ),
  Prodotto(nome: "lampone",),
  Prodotto(nome: "sedano"),

  /*
    Prodotto(nome: "fragola", icona: "bello"),
    Prodotto(nome: "anguria", icona: "bello"),
    Prodotto(nome: "ananas", icona: "bello"),
    Prodotto(nome: "uva", icona: "bello"),
    Prodotto(nome: "zenzero", icona: "bello"),
    Prodotto(nome: "melograno", icona: "bello"),


     */
];


List<Prodotto> prodottiScelti = [];

// Vista di una griglia con i prodotti
// La griglia superiore mostra i prodotti selezionati, mentre la griglia inferiore rapprenta i prodotti disponibili


class MakeOrderState extends State<MakeOrder> {

  bool isLoadState;

  void state() {
    setState((){});
  }

  @override
  void initState() {

    final CollectionReference ordini = FirebaseFirestore.instance.collection('ordini');
    super.initState();
    ordini.where('utente', isEqualTo: Global.u, ).where('stato', isEqualTo: "elaborazione").get().then((data) {
      setState(() {
        List list = data.docs.map((e) => e.data()['id']).toList();
        if (list.length == 0)
          isLoadState = false;
        else{
          isLoadState = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await showDialog<String>(
              context: context,
              builder: (BuildContext context) => new WarningMessage(order: list.first.toString(), parent: this),
            );
          });
        }
      });

    }).catchError((e) {
      Navigator.pop(context, "an error");
    });
  }

  @override
  Widget build(BuildContext context) {


    return isLoadState != null
      ? MaterialApp(
      title: "make order",
      home: Scaffold(
        backgroundColor: Constants.lightBrown,
        appBar: AppBar(
          backgroundColor: Constants.darkBrown,
          elevation: 0.0,
          title: Row(
            children: [
              Expanded(

                child: Container(
                  transform: Matrix4.translationValues(-25.0, 0.0, 0.0),
                  child: Text('annulla',
                    style: TextStyle(fontSize: 15),
                  ),
                ),

              ),
              Center(
                child: Text('MakeOrder',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(''),
                ),
              ),

            ],
          ),
          leading:
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () { Navigator.pop(context);
                },
              )
          ),
        body: CustomScrollView(
          slivers: <Widget>[

            SliverFixedExtentList(

              itemExtent: 70.0,
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {

                        return Padding(
                          padding: const EdgeInsets.only( left: 15.0),
                          child: Row(
                            children: [
                              Text("Ordinazione per: ${Global.u} ",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        );
                        },
                  childCount: 1
              ),
            ),

            
            SliverGroupBuilder(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: prodottiScelti.length != 0 ? SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return  Product_tile(state: state, p: prodottiScelti[index], isSelect: false,);

                  },
                  childCount: prodottiScelti.length,
                ),
              ) :
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding( padding: EdgeInsets.all(10.0),
                        child: Image(
                          image: AssetImage('assets/Fruits.png'),
                          width: 200,
                          height: 200,
                        )
                    )
                  ],
                ),
              )
            ),

            SliverGroupBuilder(
              child: SliverFixedExtentList(
                itemExtent: 13.0,
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        child:
                        Text("",
                          style: TextStyle(
                            color: Constants.sand,
                          ),
                        ),
                        color: Constants.lightBrown,
                      );
                    },
                    childCount: 1
                ),
              ),
            ),

            SliverGroupBuilder(
              margin: EdgeInsets.only(
                  left: 5.0,
                  right: 5.0
              ),
              decoration: BoxDecoration(
                color: Constants.mediumBrown,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),

              ),
              child: SliverFixedExtentList(
                itemExtent: 50.0,

                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        alignment: Alignment.center,
                        child:
                        Text("Scegli prodoti",
                          style: TextStyle(
                            color: Constants.sand,
                          ),

                        ),
                        color: Constants.mediumBrown,
                      );
                    },
                    childCount: 1
                ),
              ),
            ),


            SliverGroupBuilder(
              margin: EdgeInsets.only(
                left: 5.0,
                right: 5.0
              ),
              decoration: BoxDecoration(
                color: Constants.mediumBrown,

              ),
              child: SliverGrid(

                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 5.0,

                  //childAspectRatio: 1.0,

                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return  Product_tile(state: state, p: prodotti_grafici[index], isSelect: true,);

                  },
                  childCount: prodotti_grafici.length,
                ),
              ),
            ),
            SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: false,
              child: Container(
                margin: EdgeInsets.only(
                    left: 5.0,
                    right: 5.0
                ),
                color: Constants.mediumBrown,
              ),
            ),
          ],
        ),
        floatingActionButton: prodottiScelti.length != 0 ? FloatingActionButton(
          heroTag: "btnSceltaProdotti",
          onPressed: () {
            Navigator.pushReplacementNamed(
                context,
                Routes.makeQuantity,
                arguments: ScreenArguments(Global.u, prodottiScelti),
            );
          },
          child: const Icon(Icons.navigate_next_rounded),
          backgroundColor: Constants.red,
        ) :
        FloatingActionButton(
          heroTag: "btnNessunProdottoScelto",
          onPressed: () {},
          child: const Icon(Icons.navigate_next_rounded),
          backgroundColor: Colors.grey,
        ),
      ),

    ) : Loading();
  }
}





