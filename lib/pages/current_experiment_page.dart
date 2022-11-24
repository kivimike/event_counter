import 'package:flutter/material.dart';
import 'package:event_counter/components/event.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrentExperimentPage extends StatefulWidget {
  const CurrentExperimentPage({Key? key}) : super(key: key);

  @override
  State<CurrentExperimentPage> createState() => _CurrentExperimentPageState();
}

class _CurrentExperimentPageState extends State<CurrentExperimentPage> {
  var counter = 0;
  String session_status = 'Start session';
  List<Event> eventList = [];

  void increment() {
    if (counter == 0){
      start_session();
    }
    setState(() {
      counter++;
      eventList.add(Event(number: counter, dateTime: DateTime.now()));
    });
  }

  void start_session(){
    setState(() {
      counter=0;
      eventList.add(Event(number: 0, dateTime: DateTime.now()));
      session_status = 'End session';
    });
  }

  void session_controller(){
    if (session_status == 'Start session'){
      start_session();
    } else if (session_status == 'End session'){
      stop_session();
    }
  }

  void decrease() {
    setState(() {
      if (counter > 0) {
        counter--;
        eventList.removeLast();
        print(eventList);
      }
    });
  }

  void stop_session(){
    setState(() {
      session_status = 'Save';
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          backgroundColor: Colors.blueGrey.shade600,
          title: Container(
              child: Text("Records",
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 28))),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.save))
          ],
        ),
        backgroundColor: Colors.blueGrey.shade900,
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SfCartesianChart(
                  primaryXAxis: DateTimeAxis(
                      isVisible: true,
                      majorGridLines: MajorGridLines(width: 0)),
                  primaryYAxis: (NumericAxis(isVisible: false)),
                  //tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    AreaSeries<Event, DateTime>(
                      dataSource: eventList,
                      xValueMapper: (Event data, _) => data.dateTime,
                      yValueMapper: (Event data, _) => data.number,
                      color: Colors.orange.shade100,
                    ),
                  ]),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                      onPressed: () {session_controller();},
                      child: Text(
                        '${session_status}',
                        style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.w400, letterSpacing: 1),
                      )),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                      onPressed: () {
                        decrease();
                      },
                      icon: Icon(Icons.exposure_minus_1),
                      color: Colors.orange),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                increment();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '${counter}',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w300,
                    color: Colors.orange.shade100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ));
  }
}
