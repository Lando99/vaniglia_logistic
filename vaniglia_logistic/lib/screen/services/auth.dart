import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/services/database.dart';
import 'package:vaniglia_logistic/screen/order/makeQuantity.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;




  /// func auth change user stream. It's return a object of user

  /*
  Stream<User> get utente{
    return _auth.authStateChanges()
    .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Utente(uid: user.uid);
      }
    });

  }

   */

  String getEmail(){
    return _auth.currentUser.email.split("@")[0] ;
  }
  String getUid(){
    return _auth.currentUser.uid ;
  }

  /// Registrazione con utente e password
  //TODO: Aggiungere il tipo di utente nella registrazione
  Future registerWithEmailAndPassword(String email, String password) async {
    try{

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );


      //await DatabaseService(uid: user.uid).updateUserDate('email', 'password', 'ruolo');
      await DatabaseService(uid: _auth.currentUser.uid).updateUserData(email,'ruolo');
      _auth.signOut();
      return null;

    }catch(e){
      if(e.toString() == "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null, null)" ||
          e.toString() == "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)"
      ){
        return e;
      }
      else {
        print(e.toString());
        return ("ERRORE: " + e.toString());
      }
    }
  }


  Future setOrderConsegnato(List<Ordine> ordini) async {
    try{

      for(int i=0;i<ordini.length;i++){
        await DatabaseService(uid: _auth.currentUser.uid).updateStatusOrder(ordini[i].id, 'consegnato');

      }


      return null;

    }catch(e){
      print(e.toString());
    }
  }



  /// Accesso con mail e password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      //FirebaseUser user = result.user;


      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      return userCredential;
    } catch (e) {

      if(e.toString() == "FirebaseError: The password is invalid or the user does not have a password. (auth/wrong-password)" ||
          e.toString() == "FirebaseError: There is no user record corresponding to this identifier. The user may have been deleted. (auth/user-not-found)"
      ){
        return e;
      }else{
        return ("ERRORE: " + e.toString());
      }



    }
  }
  /// sing out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future addOrder(String utente, List<Prodotto_Quantita> list) async {
    try{
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
      await DatabaseService(uid: _auth.currentUser.uid).updateOrdiniData(utente, date, list);
    }catch(e){
      print(e);
    }
  }


}