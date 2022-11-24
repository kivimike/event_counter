import 'package:flutter/material.dart';

import 'package:event_counter/pages/home_page.dart';
import 'package:event_counter/pages/current_experiment_page.dart';

const String homePage = 'home';
const String currentExperiment = 'curExp';

Route<dynamic> controller(RouteSettings routeSettings){
  switch (routeSettings.name){
    case homePage:
      return MaterialPageRoute(builder: (context)=>HomePage());
    case currentExperiment:
      return MaterialPageRoute(builder: (context)=>CurrentExperimentPage());
    default:
      throw('Path does not exist');
  }
}

