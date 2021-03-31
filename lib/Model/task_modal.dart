import 'package:hive/hive.dart';

 part 'task_modal.g.dart';

 @HiveType(typeId: 0)
class TaskModel{
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String date;
  TaskModel({this.title, this.description, this.date});

}