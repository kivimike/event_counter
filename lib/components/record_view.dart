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

  @override
  void initState() {
    db.loadData();
    record = db.records[widget.index];
    super.initState();
  }

  String eventsPerInterval(){
    if (record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds < 60){
      return 'Events per second: ${((record['events'].length - 1) / record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds).toStringAsFixed(1)}';
    }

    return 'Events per minute: ${((record['events'].length - 1) / record['dateTimeEnd'].difference(record['dateTimeStart']).inSeconds * 60).toStringAsFixed(1)}';
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
              height: MediaQuery.of(context).size.height * 0.6,
              child: SfCartesianChart(
                  title: ChartTitle(
                    text: record['recordName'],
                    textStyle: TextStyle(
                        color: Colors.orange.shade50,
                        fontSize: 28,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w300),
                  ),
                  primaryXAxis: DateTimeAxis(
                      isVisible: true, majorGridLines: MajorGridLines(width: 0)),
                  primaryYAxis: (NumericAxis(isVisible: false)),
                  //tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    AreaSeries<dynamic, DateTime>(
                      dataSource: record['events'],
                      xValueMapper: (data, _) => data.dateTime,
                      yValueMapper: (data, _) => data.number,
                      color: Colors.orange.shade100,
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Total events: ${record['events'].length - 1}',
                style: TextStyle(
                    color: Colors.orange.shade50,
                    fontSize: 28,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(eventsPerInterval(),
                style: TextStyle(
                    color: Colors.orange.shade50,
                    fontSize: 28,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
    );
  }
}
