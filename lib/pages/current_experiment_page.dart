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

  int inputControllersNumber = 1;
  List counter = [0, 0, 0];
  bool sessionIsActive = true;
  String session_status = 'Start session';
  Map eventList = {0: [], 1: [],2: []};
  late DateTime dateTimeStart;
  late DateTime dateTimeEnd;

  List colors = [Colors.orange.shade400, Colors.green.shade400, Colors.red.shade400];
  Map fontsizes = {1: 80.0, 2: 80.0, 3: 50.0};

  void increment(int i) {
    if (sessionIsActive == true) {
      if (counter[0] == 0 && counter[1] == 0 && counter[2] == 0) {
        start_session();
      }
      setState(() {
        counter[i]++;
        eventList[i].add(Event(number: counter[i], dateTime: DateTime.now()));
      });
    }
  }

  void start_session() {
    dateTimeStart = DateTime.now();
    setState(() {
      counter = [0,0,0];
      for (int i = 0; i < counter.length; ++i){
        eventList[i].add(Event(number: 0, dateTime: DateTime.now()));
      }
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

  void decrease(i) {
    if (sessionIsActive == true) {
      setState(() {
        if (counter[i] > 0) {
          counter[i]--;
          eventList[i].removeLast();
          //print(eventList);
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

  void save() {
    if (sessionIsActive == true) {
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
    //print(db.records);
    // Navigator.pushReplacementNamed(context, route.homePage);
    controller.clear();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void cancelDialogBox() {
    controller.clear();
    Navigator.pop(context);
  }

  void saveDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SaveAlertBox(
              onSave: save, onCancel: cancelDialogBox, controller: controller);
        });
  }

  void addControllers(){
    if(inputControllersNumber < 3){
      inputControllersNumber++;
    }
  }

  void removeControllers(){
    if(inputControllersNumber > 1){
      inputControllersNumber--;
    }
  }

  List<Widget> inputControllers() {

    double icWidth = MediaQuery.of(context).size.width / inputControllersNumber;
    List<Widget> ics = [];
    for (int i = 0; i < inputControllersNumber; ++i) {
      ics.add(Column(
        children: [
          GestureDetector(
            onTap: () {
              increment(i);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: icWidth,
              child: Text(
                '${counter[i]}',
                style: TextStyle(
                  fontSize: fontsizes[inputControllersNumber],
                  fontWeight: FontWeight.w300,
                  color: colors[i],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                decrease(i);
              },
              icon: Icon(Icons.exposure_minus_1),
              color: Colors.orange),
        ],
      ));
    }
    return ics;
  }

  List<ChartSeries> charts(){
    List<ChartSeries> charts = [];
    for (int i = 0; i < counter.length; ++i){
      charts.add(
        AreaSeries<dynamic, DateTime>(
          dataSource: eventList[i],
          xValueMapper: (data, _) => data.dateTime,
          yValueMapper: (data, _) => data.number,
          color: colors[i],
          opacity: 0.8,
          borderColor: Colors.blueGrey.shade50,
          borderWidth: 1
        ),
      );
    }
    return charts;
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
          actions: [
            IconButton(
                onPressed: () {
                  saveDialog();
                },
                icon: Icon(Icons.save))
          ],
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
                  series: charts()),
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
                  padding: const EdgeInsets.all(0),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          addControllers();
                        });
                      },
                      icon: Icon(Icons.add),
                      color: Colors.orange),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          removeControllers();
                        });
                      },
                      icon: Icon(Icons.remove),
                      color: Colors.orange),
                ),
              ],
            ),
            Row(
              children: inputControllers(),
            )
          ],
        ));
  }
}
