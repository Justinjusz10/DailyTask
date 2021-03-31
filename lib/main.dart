import 'package:flutter/material.dart';
import 'package:DailyTaskApp/screens/splash_screen.dart';
import 'package:DailyTaskApp/Model/task_modal.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


const String dataBoxName = "data";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(TaskModalAdapter());
  await Hive.openBox<TaskModel>(dataBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
