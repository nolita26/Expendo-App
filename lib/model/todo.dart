import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  final DateTime date;
  final DateTime time;
  final String task;
  final String description;
  bool isFinish;
  final int todoType;

  Todo({
    @required this.id,
    @required this.date,
    @required this.time,
    @required this.task,
    @required this.description,
    @required this.isFinish,
    @required this.todoType,
  });
}

enum TodoType { TYPE_TASK, TYPE_EVENT }
