import 'package:flutter/material.dart';
import 'package:DailyTaskApp/Model/task_modal.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:DailyTaskApp/Constants/constants.dart';

 typedef callBack = Function(bool, TaskModel);

class AddTask extends StatefulWidget {
  final String appTitle;
  final TaskModel model;
  AddTask(this.appTitle,this.model);

  @override
    State<StatefulWidget> createState() {
    return _AddTaskState(this.appTitle,this.model);
  }
}

class _AddTaskState extends State<AddTask> {
  String appTitle;
  final TaskModel model;

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool _validate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AddTaskState(this.appTitle,this.model);

  @override
  Widget build(BuildContext context) {
    _title.text = model != null ? model.title : '' ;
		_description.text = model != null ? model.description : '' ;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
           backgroundColor: Constants.colors.green,
            title: Text(this.appTitle),
          ),
          body: initBody(),
        ),
        onWillPop: () => moveToLastScreen(null));
  }

initBody() {
    return new Container(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
                          child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[300],
                    ),
                    controller: _title,
                    decoration: new InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.colors.green),
                        ),
                        
                        hintText: "Enter your task",
                        errorText:
                            _validate ? 'This field can\'t be empty' : null,
                        errorStyle: TextStyle(color: Colors.red)),
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                              if (!nameValidator(value)) {
                                return "Not a valid name";
                              }
                              return null;
                            },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyle(
                      color: Colors.green[300]
                    ),
                    controller: _description,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Constants.colors.green),
                        ),
                      hintText: 'Enter description(optional)',
                    ),
                      onChanged: (String value) async {
                      //updateDescription();
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        validateAndSave();
                      },
                      child: (model != null) ? Text('Update') : Text('Submit'),
                      textColor: Colors.white,
                      color: Constants.colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

    void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      print('Form is valid');
      _save();
    } else {
      print('Form is invalid');
    }
  }
  
   bool nameValidator(String value) {
    final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

    if (validCharacters.hasMatch(value))
      return true;
    else
      return false;
  }

    updateTitle() {

    }

    updateDescription() {

    }

    _save() {
      print(_title.text);
      var description = _description.text;
      TaskModel model = TaskModel(title: _title.text, description: description != '' ? description : '',date: DateFormat.yMMMd().add_jm().format(DateTime.now()));
      moveToLastScreen(model);
    }

    moveToLastScreen(model) {
    Navigator.pop(context, model);
  }
}