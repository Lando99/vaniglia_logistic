import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart' as Constants;
import 'package:vaniglia_logistic/screen/home/home.dart';


/**
 * Diagramma a torta
 * */

class CardStatistic extends StatefulWidget {

  final HomeState parent;
  CardStatistic({this.parent});

  @override
  _CardStatisticState createState() => _CardStatisticState();
}


String valuePuntoVendita = 'tutti';
String valuePeriodo = 'settimana';
class _CardStatisticState extends State<CardStatistic> {


  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];



    return  Container(
        child: Column(
          children: [
            Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  DropdownButton<String>(
                    value: valuePuntoVendita,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.deepPurple
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        valuePuntoVendita = newValue;
                      });
                      widget.parent.setState(() {});
                      },
                    items: <String>['tutti', 'Brentelle', 'Ipercity', 'Palladio']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                  ),
                  DropdownButton<String>(
                    value: valuePeriodo,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                        color: Colors.deepPurple
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        valuePeriodo = newValue;
                      });
                      widget.parent.setState(() {});
                      },
                    items: <String>['settimana', 'mese', '3 mesi', 'anno']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        })
                        .toList(),
                  ),
              ]
            ),


            SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                title: ChartTitle(text: 'Statistica prodotti ordinati'),
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    pointColorMapper:(ChartData data,  _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    radius: '90%',
                    // Segments will explode on tap
                    explode: true,
                  )
                ]
            ),
          ],
        )
    );


  }



}



class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}
