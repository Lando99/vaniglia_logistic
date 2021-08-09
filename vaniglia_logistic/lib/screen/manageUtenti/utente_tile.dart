import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/models/user.dart';
import '../../constants.dart' as Constants;

class UtenteTile extends StatelessWidget {

  final Utente utente;

  UtenteTile({this.utente});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:9.8),
      child: Card(
        color: Constants.lightGreen,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(utente.email,
                style: TextStyle(color: Colors.white),),
              Text(utente.societa,
                style: TextStyle(color: Colors.white),),

            ],
          ),
          subtitle: Text(utente.ruolo),
        ),
      ),

    );

  }
}
