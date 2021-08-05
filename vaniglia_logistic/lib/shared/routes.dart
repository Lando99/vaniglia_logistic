import 'package:vaniglia_logistic/models/user.dart';
import 'package:vaniglia_logistic/screen/authenticate/register.dart';
import 'package:vaniglia_logistic/screen/deliveries/deliveries.dart';
import 'package:vaniglia_logistic/screen/viewOrdini/viewOrdini.dart';
import 'package:vaniglia_logistic/screen/home/home.dart';
import 'package:vaniglia_logistic/screen/impostazioni/preference.dart';
import 'package:vaniglia_logistic/screen/manageUtenti/manageUtenti.dart';
import 'package:vaniglia_logistic/screen/makeOrder/confirmOrder.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeQuantity.dart';
import 'package:vaniglia_logistic/screen/makeOrder/makeOrder.dart';
import 'package:vaniglia_logistic/screen/makeOrder/selectUtente.dart';

class Routes {

  static const String home = Home.routeName;
  static const String register = Register.routeName;

  static const String ordini = Ordini.routeName;
  static const String settingsForm = SettingsForm.routeName;
  static const String manageUtenti = ManageUtenti.routeName;

  static const String selectUtente = SelectUtente.routeName;
  static const String makeOrder = MakeOrder.routeName;
  static const String makeQuantity = MakeQuantity.routeName;
  static const String confirmOrder = ConfirmOrder.routeName;

  static const String deliveries = Deliveries.routeName;

}