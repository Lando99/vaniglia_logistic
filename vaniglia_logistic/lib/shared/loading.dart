import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

import '../../constants.dart' as Constants;

///Classe per l'animazione di caricamento
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.mediumBrown,
      child: Center(
        child: SpinKitChasingDots(
          color: Constants.darkBrown,
          size: 50.0,
        ),
      ),
    );
  }
}

