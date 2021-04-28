import 'package:flutter/material.dart';
import 'package:vaniglia_logistic/screen/authenticate/register.dart';
import 'package:vaniglia_logistic/screen/authenticate/sign_in.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingIn(),
    );
  }
}
