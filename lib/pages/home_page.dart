import 'package:event_counter/components/main_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:event_counter/components/routes.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      floatingActionButton: MainMenuButton(onPressed: () => Navigator.pushNamed(context, route.currentExperiment),),
      backgroundColor: Colors.blueGrey.shade900,
    );
  }
}
