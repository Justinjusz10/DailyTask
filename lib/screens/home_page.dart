import 'package:DailyTaskApp/Model/task_modal.dart';
import 'package:flutter/material.dart';
import 'package:DailyTaskApp/screens/add_task.dart';
import 'package:DailyTaskApp/Constants/constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';


const String dataBoxName = "data";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isUpdate;
  int key;
    @override
  void initState() {
    super.initState();
    dataBox = Hive.box<TaskModel>(dataBoxName);
  }
    Box<TaskModel> dataBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(actions: [],
      title: Text(Constants.appName),
      backgroundColor: Constants.colors.green,
      ),

      body: initBody(context),
            floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Constants.colors.green,
        onPressed: () {
          isUpdate = false;
          navigateToDetail(Constants.addtask,null);
        } 
      ),
    );
  }

  Widget initBody(context) {
    return SingleChildScrollView (
      child: Column(
        children: [
           ValueListenableBuilder(valueListenable: dataBox.listenable(), builder: (context, Box<TaskModel> items, _){
           List<int> keys = items.keys.cast<int>().toList();
           keys.sort((b, a) => a.compareTo(b));
           print('keys length: ${keys.length}');
           return ListView.builder(
             itemBuilder: (_ ,int position) {
               final int key = keys[position];
               final TaskModel data = items.get(key);
               return getTodoListView(data,key);
           },
           itemCount: keys.length,
           shrinkWrap: true,
           scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
           );

          }            
      )
        ]
    )
    );
  }

    Widget getTodoListView(dynamic task,int key) {
      var color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return Card(
          color: Colors.transparent,
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                color:  Colors.blueGrey[50],
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                ),
                border: Border.all(
                  color: color
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(task.title,style: TextStyle(fontWeight: FontWeight.bold,color: color)),
                      SizedBox(height: 10,),
                      Text(task.description,style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black),),
                       SizedBox(height: 8,),
                      Text('update at ${task.date}',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey,fontSize: 11),)
                      ],
                    ),
                  ),
                  menuList(task,key)
                ],
              ),
            ),
          )
        );
  }

  Widget menuList(task,key) {
    return PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              this.key = key;
              if(value.compareTo("Edit") == 0){
                isUpdate = true;
                navigateToDetail(Constants.editTask, task);
              } else {
                showAlertDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return ["Edit", "Delete"].map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          );
  }

  void navigateToDetail(String title,TaskModel model) async {
    TaskModel result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTask(title,model);
    }));
    if (result != null) {
      setState(() {
        print(result.title);
         updateDertails(result);
      });
    } else {
      print('datais null');
    }
  }

  updateDertails(model) {
    if (isUpdate) {
      dataBox.put(key, model);
    } else {
      dataBox.add(model);
    }
  showToast(isUpdate ? Constants.taskUpdated : Constants.taskAdded);

  }

  showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(Constants.alerts.cancel),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(Constants.alerts.proceed),
    onPressed:  () {
     Navigator.pop(context);
      setState(() {
        dataBox.delete(key);
      });
      showToast(Constants.taskDeleted);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(Constants.appName),
    content: Text(Constants.alerts.deleteMessage),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  }
}