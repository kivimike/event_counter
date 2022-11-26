import 'package:event_counter/components/save_alert_box.dart';
import 'package:event_counter/database/database.dart';
import 'package:flutter/material.dart';
import 'package:event_counter/components/event.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:event_counter/components/routes.dart' as route;

class CurrentExperimentPage extends StatefulWidget {
  const CurrentExperimentPage({Key? key}) : super(key: key);

  @override
  State<CurrentExperimentPage> createState() => _CurrentExperimentPageState();
}

class _CurrentExperimentPageState extends State<CurrentExperimentPage> {

  ClickerDatabase db = ClickerDatabase();
  TextEditingController controller = TextEditingController();
  
  var counter = 0;
  bool sessionIsActive = true;
  String session_status = 'Start session';
  List<Event> eventList = [];
  late DateTime dateTimeStart;
  late DateTime dateTimeEnd;


  void increment() {
    if (sessionIsActive == true) {
      if (counter == 0) {
        start_session();
      }
      setState(() {
        counter++;
        eventList.add(Event(number: counter, dateTime: DateTime.now()));
      });
    }
  }

  void start_session() {
    dateTimeStart = DateTime.now();
    setState(() {
      counter = 0;
      eventList.add(Event(number: 0, dateTime: DateTime.now()));
      session_status = 'Stop session';
    });
  }

  void session_controller() {
    if (session_status == 'Start session') {
      start_session();
    } else if (session_status == 'Stop session') {
      stop_session();
    }
  }

  void decrease() {
    if (sessionIsActive == true) {
      setState(() {
        if (counter > 0) {
          counter--;
          eventList.removeLast();
          print(eventList);
        }
      });
    }
  }

  void stop_session() {
    dateTimeEnd = DateTime.now();
    sessionIsActive = false;
    setState(() {
      session_status = 'Session stopped';
    });
  }
  
  void save(){
    if (sessionIsActive == true){
      stop_session();
    }
    db.loadData();
    Map record = {
      'recordName': controller.text,
      'dateTimeStart': dateTimeStart,
      'dateTimeEnd': dateTimeEnd,
      'events': eventList

    };
    db.records.insert(0, record);
    db.updateDatabase();
    print(db.records);
    // Navigator.pushReplacementNamed(context, route.homePage);
    controller.clear();
    Navigator.pop(context);
    Navigator.pop(context);

  }

  void cancelDialogBox() {
    controller.clear();
    Navigator.pop(context);
  }

  void saveDialog(){
    showDialog(context: context, builder: (context){
      return SaveAlertBox(onSave: save, onCancel: cancelDialogBox, controller: controller);
    });
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
          actions: [IconButton(onPressed: () {saveDialog();}, icon: Icon(Icons.save))],
        ),
        resizeToAvoidBottomInset: false,
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
                      onPressed: () {
                        session_controller();
                      },
                      child: Text(
                        '${session_status}',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1),
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
