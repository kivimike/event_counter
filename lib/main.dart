import 'package:event_counter/components/event.dart';
import 'package:event_counter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:event_counter/components/routes.dart' as route;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive..registerAdapter(EventAdapter());

  // open a box
  await Hive.openBox("Clicker_DB");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
    );
  }
}
