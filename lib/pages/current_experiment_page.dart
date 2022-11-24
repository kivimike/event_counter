import 'package:flutter/material.dart';

class CurrentExperimentPage extends StatefulWidget {
  const CurrentExperimentPage({Key? key}) : super(key: key);

  @override
  State<CurrentExperimentPage> createState() => _CurrentExperimentPageState();
}

class _CurrentExperimentPageState extends State<CurrentExperimentPage> {

  var counter = 0;

  void increment(){
    setState(() {
      counter++;
    });
  }

  void decrease(){
    setState(() {
      counter--;
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
        ),
        backgroundColor: Colors.blueGrey.shade900,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              color: Colors.red,
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                      onPressed: () {decrease();},
                      icon: Icon(Icons.exposure_minus_1),
                      color: Colors.orange),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {increment();},
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Text('${counter}', style: TextStyle(
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
