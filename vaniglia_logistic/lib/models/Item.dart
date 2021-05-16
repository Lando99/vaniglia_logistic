// Classe di Item
import 'package:flutter/widgets.dart';

class Item {
  Item({ this.expandedValue, this.headerValue,
    this.isExpanded,this.color
  });

  Widget expandedValue;
  Widget headerValue;
  Color color;
  bool isExpanded;
}