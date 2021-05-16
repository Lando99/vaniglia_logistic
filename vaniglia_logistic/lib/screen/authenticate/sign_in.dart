import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:vaniglia_logistic/shared/constants.dart';
import 'package:vaniglia_logistic/shared/loading.dart';

import '../../constants.dart' as Constants;

///Widget for sign in on the application
class SingIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Constants.mediumBrown,
      appBar: AppBar(
        backgroundColor: Constants.darkBrown,
        elevation: 0.0,
        title: Text('Accedi a Vaniglia'),
        actions: [],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputeDecoration.copyWith(hintText: "Email"),
                validator: (val) => val.isEmpty ? 'iserisci email' : null,
                keyboardType: TextInputType.emailAddress,

                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputeDecoration.copyWith(hintText: "Password"),
                validator: (val) => val.isEmpty ? 'password non valida' : null,
                obscureText: true,
                onChanged: (val){
                  password = val;
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Accedi',
                    style: TextStyle(color: Colors.white),
                  ),

                  onPressed: ()async{
                    if(_formKey.currentState.validate()){

                      setState(() {
                        loading = true;
                      });

                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result.toString() == "FirebaseError: The password is invalid or the user does not have a password. (auth/wrong-password)"){
                        setState(() {
                          loading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('password non valida!'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else if(result.toString() == "FirebaseError: There is no user record corresponding to this identifier. The user may have been deleted. (auth/user-not-found)"){
                        setState(() {
                          loading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('Utente non trovato!'),
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      }
                      else if(result.toString().contains('ERRORE: ')){
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
                      }
                    }

                  }

              ),
              SizedBox(height: 20.0),

              /**TODO: Remove button, use unly for test*/
              ElevatedButton(
                onPressed: ()async{
                  dynamic result = await _auth.signInWithEmailAndPassword("admin@vaniglia.it", "password");
                },
                child: Text(
                  'Admin',
                  style: TextStyle(color: Colors.white),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}

