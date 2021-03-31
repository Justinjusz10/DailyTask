
import 'dart:ffi';

import 'package:flutter/material.dart';

class Constants {
static var appName = 'My Task';
static var addtask = 'Add my task';
static var editTask = 'Edit Your task';
static var taskAdded = 'Task addedd';
static var taskUpdated = 'Task updated';
static var taskDeleted = 'Task deleted';

static var colors = ColorsConstants();
static var alerts = AlertConstants();


}
 class ColorsConstants {
  var green = Colors.green[300];
}

class AlertConstants {
   var deleteMessage = 'Are you sure you want to delete the task';
   var proceed = 'Yes,proceed';
   var cancel = 'No';
}