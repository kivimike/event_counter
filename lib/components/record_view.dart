import 'dart:math';
import 'package:event_counter/components/proba_point.dart';
import 'package:event_counter/components/event.dart';
import 'package:event_counter/database/database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RecordView extends StatefulWidget {
  final index;

  const RecordView({super.key, required this.index});

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  ClickerDatabase db = ClickerDatabase();
  late final record;
  static const int NUM_CONTROLLERS = 3;
  List colors = [
    Colors.orange.shade400,
    Colors.green.shade400,
    Colors.red.shade400
  ];
  Map fontsizes = {1: 80.0, 2: 80.0, 3: 50.0};

  @override
  void initState() {
    db.loadData();
    record = db.records[widget.index];
    super.initState();
  }

  String eventsPerInterval(int numEvents) {
    if (record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds <
        60) {
      return '${(numEvents / record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds).toStringAsFixed(1)}';
    }

    return '${(numEvents / record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds * 60).toStringAsFixed(1)}';
  }

  String eventsPerIntervalName() {
    if (record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds <
        60) {
      return 'Events per second';
    }

    return 'Events per minute';
  }

  int factorial(int n) {
    return n == 1 ? 1 : n * factorial(n - 1);
  }

  double calculateProba(int m, double lambda) {
    return ((1 / pow(e, lambda)) * pow(lambda, m) / factorial(m)).clamp(0, 1);
  }

  Map probaDataset() {
    Map dataset = {};
    int usedControllers = countUsedControllers();
    for (int i = 0; i < usedControllers; ++i) {
      dataset[i] = [];
      double lambda =
          double.parse(eventsPerInterval(record['events'][i].length - 1));
      for (int m = 1; m < 10; ++m) {
        dataset[i]
            .add(ProbaPoint(probability: calculateProba(m, lambda), m: m));
      }
    }
    return dataset;
  }

  Widget Probabilities() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: SfCartesianChart(
        borderWidth: 0,
          backgroundColor: Colors.transparent,
          plotAreaBorderWidth: 0,
          title: ChartTitle(
            text: 'Probabilities',
            textStyle: TextStyle(
                color: Colors.orange.shade50,
                fontSize: 20,
                letterSpacing: 2,
                fontWeight: FontWeight.w300),
          ),
          primaryXAxis: NumericAxis(
              isVisible: true, majorGridLines: MajorGridLines(width: 0)),
          primaryYAxis: (NumericAxis(
              isVisible: true,
              majorGridLines: MajorGridLines(width: 0),
              labelPosition: ChartDataLabelPosition.outside,
          tickPosition: TickPosition.inside)),
          //tooltipBehavior: _tooltipBehavior,
          series: probabilityCharts()),
    );
  }

  List<ChartSeries> charts() {
    List<ChartSeries> charts = [];
    for (int i = 0; i < NUM_CONTROLLERS; ++i) {
      charts.add(
        AreaSeries<dynamic, DateTime>(
            dataSource: record['events'][i],
            xValueMapper: (data, _) => data.dateTime,
            yValueMapper: (data, _) => data.number,
            color: colors[i],
            opacity: 0.8 - i * 0.05,
            borderColor: Colors.blueGrey.shade50,
            borderWidth: 1),
      );
    }
    return charts;
  }

  List<ChartSeries> probabilityCharts() {
    Map dataset = probaDataset();
    List<ChartSeries> charts = [];
    for (int i = 0; i < countUsedControllers(); ++i) {
      charts.add(
        AreaSeries<dynamic, dynamic>(
            dataSource: dataset[i],
            xValueMapper: (data, _) => data.m,
            yValueMapper: (data, _) => data.probability,
            color: colors[i],
            opacity: 0.8 - i * 0.05,
            borderColor: Colors.blueGrey.shade50,
            borderWidth: 1),
      );
    }
    return charts;
  }

  int totalEvents() {
    int total = 0;
    for (int i = 0; i < NUM_CONTROLLERS; ++i) {
      int len = record['events'][i].length ?? 1;
      total += len - 1;
    }
    return total;
  }

  int percentage(int controllerNum) {
    int len = record['events'][controllerNum].length - 1;
    //print(len);
    //print(totalEvents());
    return 100 * len ~/ totalEvents();
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  Widget TextLine(String text, double fontsize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.orange.shade50,
            fontSize: fontsize,
            letterSpacing: 2,
            fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
    );
  }

  int countUsedControllers() {
    int res = 0;
    for (int i = 0; i < NUM_CONTROLLERS; ++i) {
      if (record['events'][i].length > 1) {
        res += 1;
      }
    }
    return res;
  }

  Widget multipleControllersData() {
    List<Widget> numberOfEvents = [];
    int usedControllers = countUsedControllers();
    for (int i = 0; i < usedControllers; ++i) {
      Text text0 = Text(
        '${record['events'][i].length - 1}',
        style: TextStyle(
            color: colors[i],
            fontSize: fontsizes[usedControllers],
            letterSpacing: 2,
            fontWeight: FontWeight.w300),
      );
      numberOfEvents.add(text0);
    }

    List<Widget> epi = [];
    for (int i = 0; i < usedControllers; ++i) {
      Text text1 = Text(
        eventsPerInterval(record['events'][i].length - 1),
        style: TextStyle(
            color: colors[i],
            fontSize: fontsizes[usedControllers],
            letterSpacing: 2,
            fontWeight: FontWeight.w300),
      );
      epi.add(text1);
    }

    List<Widget> percents = [];
    for (int i = 0; i < usedControllers; ++i) {
      Text text2 = Text(
        percentage(i).toString(),
        style: TextStyle(
            color: colors[i],
            fontSize: fontsizes[usedControllers],
            letterSpacing: 2,
            fontWeight: FontWeight.w300),
      );
      percents.add(text2);
    }

    Widget grid = Column(
      children: [
        TextLine('Number of events', 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: numberOfEvents,
          ),
        ),
        TextLine(eventsPerIntervalName(), 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: epi,
          ),
        ),
        TextLine('Percentage', 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: percents,
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: grid,
    );
  }

  Widget showDetails() {
    if (countUsedControllers() == 1) {
      return Column(children: []);
    }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.3,
              color: Colors.orange,
            ),
            Text(
              'Details',
              style: TextStyle(
                  color: Colors.orange, letterSpacing: 2.0, fontSize: 12),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.3,
              color: Colors.orange,
            ),
          ],
        ),
      ),
      multipleControllersData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: Colors.blueGrey.shade600,
        title: Container(
            child: const Text("Records",
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 28))),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey.shade900,
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: SfCartesianChart(
                title: ChartTitle(
                  text: record['recordName'],
                  textStyle: TextStyle(
                      color: Colors.orange.shade50,
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300),
                ),
                primaryXAxis: DateTimeAxis(
                    isVisible: true, majorGridLines: MajorGridLines(width: 0)),
                primaryYAxis: (NumericAxis(isVisible: false)),
                //tooltipBehavior: _tooltipBehavior,
                series: charts()),
          ),
          TextLine('Total events', 16),
          TextLine('${totalEvents()}', 38),
          TextLine(eventsPerIntervalName(), 16),
          TextLine(eventsPerInterval(totalEvents()), 38),
          TextLine('Duration', 16),
          TextLine(
              '${format(Duration(seconds: record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds))}',
              38),
          showDetails(),
          Probabilities(),
        ],
      ),
    );
  }
}
