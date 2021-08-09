// Classe che mette in relazione il prodotto e la sua quantia' durante la generazione di un ordine
import 'package:vaniglia_logistic/models/prodotti.dart';

class Prodotto_Quantita{

  final Prodotto p;
  double qta;

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

List<Prodotto> prodottoQuantitaToProdotto( List<Prodotto_Quantita> prodotti){
  List<Prodotto> aux = [];
  for(int i = 0; i<prodotti.length; i++){
    aux.add(Prodotto(nome: prodotti[i].p.nome));
  }
  return aux;

}