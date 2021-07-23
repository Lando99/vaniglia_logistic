import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:vaniglia_logistic/models/ordine.dart';
import 'package:vaniglia_logistic/services/auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants.dart' as Constants;


/**
 * Diagramma a torta
 * */

class CardStatistic extends StatefulWidget {
  @override
  _CardStatisticState createState() => _CardStatisticState();
}

class _CardStatisticState extends State<CardStatistic> {



  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];

    ChartData data = ChartData("fdxgfhvbjn",0,null);
    return  Container(
        child: Column(
          children: [

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
