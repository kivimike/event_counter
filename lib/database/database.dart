import 'package:hive_flutter/hive_flutter.dart';

final _box = Hive.box("Clicker_DB");

class ClickerDatabase {
  List records = [];


  void loadData() {
    records = _box.get('EXPERIMENTS') ?? [];
  }

  void updateDatabase() {
    _box.put('EXPERIMENTS', records);
  }

}