
import 'package:flutter/material.dart';

class WarningMessage extends StatefulWidget {
  @override
  _WarningMessageState createState() => _WarningMessageState();
}

class _WarningMessageState extends State<WarningMessage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ordinazione gia\' effettuato'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Ordinazione gia fatta.'),
            Text('Selezionare come procedere(BETA--tutte le opzioni fanno tornare idietro)'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Annulla'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Modifica'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Elimina'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}