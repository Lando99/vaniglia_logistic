import 'package:cloud_firestore/cloud_firestore.dart';

/// Classed Evento usato nella sezione del calendario
class Evento{

  String id; //id utente
  Timestamp date;

  Evento ({this.id = "",this.date = null});
}