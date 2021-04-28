/**
 * Classe user che contiene le informazione dell'utente
 */
//TODO: aggiungere le informazioni di che tipo di utente si e' loggato e quindi in base a che permessi ha fare determinate cose


class Utente{

  final String uid; //id utente
  final String email;
  final String ruolo;

  Utente ({this.uid,this.email = "", this.ruolo=""});

}
