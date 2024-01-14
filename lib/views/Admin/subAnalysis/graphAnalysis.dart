
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Models/stallAnalysis.dart';


class graphAnalysis extends StatefulWidget {
  String uid;
  graphAnalysis({Key? key, required this.uid}) : super(key: key);

  @override
  State<graphAnalysis> createState() => _graphAnalysisState();
}

class _graphAnalysisState extends State<graphAnalysis> {

  late List<GDPData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  AnalysisModel analysisModel = AnalysisModel();

  int valueCleanliness=0;
  int valueQuality=0;
  int valueServices=0;

  @override
  void initState() {

    _tooltipBehavior = TooltipBehavior(enable: true);

    FirebaseFirestore.instance
        .collection('StallUsers')
        .doc(widget.uid)
        .collection('Analysis')
        .doc('Overall')
        .get()
        .then((value) {
      analysisModel = AnalysisModel.fromMap(value.data());
      valueCleanliness = int.parse("${analysisModel.totalValueCleanliness}");
      valueQuality = int.parse("${analysisModel.totalValueQuality}");
      valueServices = int.parse("${analysisModel.totalValueServices}");
      setState(() {});

      _chartData = getChartData(valueCleanliness, valueQuality, valueServices);





    });
    super.initState();
  }


  Widget build(BuildContext context)  {

    // print("${analysisModel.totalValueQuality}");
    return SafeArea(
        child: Scaffold(
          body: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
            title: ChartTitle(text: 'Data Visualization In Bar Chart'),
            legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            tooltipBehavior: _tooltipBehavior,
            series: <ChartSeries<GDPData, String>>[
              BarSeries<GDPData, String>(
                dataSource: _chartData,
                xValueMapper: (GDPData data,_) => data.type,
                yValueMapper: (GDPData data,_) => data.value,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                name: 'Feedback Analysis',
                enableTooltip: true,
              )
            ],
          ),
        )
    );
  }
  List<GDPData> getChartData(int valueCleanliness, int valueQuality, int valueServices) {
    final List<GDPData> chartData = [
      GDPData('Stall Cleanliness',valueCleanliness),
      GDPData('Food Quality', valueQuality),
      GDPData('Customer Service', valueServices),
    ];
    return chartData;
  }
}



class GDPData {
  GDPData(this.type, this.value);
  final String type;
  final int value;
}