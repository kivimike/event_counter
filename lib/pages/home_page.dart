import 'package:event_counter/components/main_menu_button.dart';
import 'package:event_counter/components/record_tile.dart';
import 'package:event_counter/database/database.dart';
import 'package:flutter/material.dart';
import 'package:event_counter/components/routes.dart' as route;
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _box = Hive.box("Clicker_DB");
  ClickerDatabase db = ClickerDatabase();

  @override
  void initState() {
    if (_box.get('EXPERIMENTS') == null) {
      _box.put('EXPERIMENTS', []);
    } else {
      db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  void deleteRecord(index) {
    setState(() {
      db.records.removeAt(index);
      db.loadData();
    });
    db.updateDatabase();
  }


  @override
  Widget build(BuildContext context) {
    //db.loadData();
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
      floatingActionButton: MainMenuButton(
        onPressed: () => Navigator.pushNamed(context, route.currentExperiment).then((_) => setState((){})),
      ),
      backgroundColor: Colors.blueGrey.shade900,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.records.length,
            itemBuilder: (context, index) {
              return RecordTile(
                name: db.records[index]['recordName'].toString(),
                date: db.records[index]['dateTimeStart'].toString(),
                onDelete: () => deleteRecord(index),
              );
            }),
      ),
    );
  }
}

