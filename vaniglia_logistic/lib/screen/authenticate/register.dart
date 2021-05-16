import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/shared/constants.dart';
import 'package:vaniglia_logistic/shared/loading.dart';

import '../../constants.dart' as Constants;

///Widget for registration of a new user
class Register extends StatefulWidget {

  static const String routeName = "/Register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";



  @override
  Widget build(BuildContext context) {
    return loading ?  Loading() : Scaffold(
      backgroundColor: Constants.lightBrown,
      appBar: AppBar(
        backgroundColor: Constants.darkBrown,
        elevation: 0.0,
        title: Text('Registrati a Vaniglia - BETA -'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Flexible(
                    child: TextFormField(
                      validator: (val) => val.isEmpty ? 'iserisci email' : null,
                      decoration: textInputeDecoration.copyWith(hintText: "BETA"),
                      onChanged: (val){
                        setState(() {
                          email = val;
                        });
                      },
                    ),

                  ),

                  Text(
                    '  @vaniglia.com',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      fontFamily: 'Raleway',
                      fontSize: 20,
                    ),
                  ),


                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputeDecoration.copyWith(hintText: "BETA"),
                validator: (val) => val.length < 6  ? 'iserisci password con più di 6 caratteri' : null,
                obscureText: true,
                onChanged: (val){
                  password = val;
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Registra',
                    style: TextStyle(color: Colors.white),
                  ),

                  onPressed: ()async{
                    if(_formKey.currentState.validate()){

                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result.toString() == "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null, null)"){
                        setState(() {
                          loading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('Email non valida!'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else if(result.toString() == "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)"){
                        setState(() {
                          loading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('Email gia\' usata!'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else if(result.toString().contains('ERRORE: ')){
                        setState(() {
                          loading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text(result.toString()),
                          action: SnackBarAction(
                            label: 'ok',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                        Navigator.pop(context);
                      }
                    }

                  }

              )

            ],
          ),
        ),
      ),
    );

  }
}
