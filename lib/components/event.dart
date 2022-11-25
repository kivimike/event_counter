import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'event.g.dart';

@HiveType(typeId: 0)
class Event{
  @HiveField(0)
  final int number;
  
  @HiveField(1)
  final DateTime dateTime;

  const Event({required this.number, required this.dateTime});

}