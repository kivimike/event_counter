import 'package:event_counter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:event_counter/components/routes.dart' as route;

void main() {
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
