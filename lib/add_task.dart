import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/task.dart';
import 'package:todo_list_app/database_helper.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTodos;
  AddTaskScreen({this.updateTodos});
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Variabel local
  // This variable is used to parse data to the database
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String    _title = "";
  String    _desc  = "";
  DateTime  _dateTime = DateTime.now();
  bool isNewTaskFinalized = false;
  int _colorChosen = 1;
  String _todoTime = '';

  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');
  TextEditingController _dateController = TextEditingController();

  _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2021),
        lastDate: new DateTime(2100)
    );
    if(picked != null) setState(() => _dateTime = picked);
    _dateController.text = _dateFormatter.format(_dateTime);
  }

  _submit() {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Task newTask = Task(
        name: _title,
        description: _desc,
        todoTime: _todoTime,
        todoDate: _dateTime,
        colorTag: _colorChosen,
        isFinalized: (isNewTaskFinalized) ? 0 : 1,
      );
      DatabaseHelper.instance.insertTodo(newTask);
      widget.updateTodos();
    }
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AddTaskAppBar(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    children: <Widget> [
                      Checkbox(
                        // Checkbox to determine whether the task is finished
                          value: isNewTaskFinalized,
                          activeColor: Colors.orange[400],
                          onChanged: (newValue){
                            setState(() {
                              isNewTaskFinalized = newValue;
                            });
                          }),
                      Text(
                        'Finalize',
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                      SizedBox(height: 10, width: 100),
                      DropdownButton(
                        onChanged: (d) {
                        setState(() {
                          _colorChosen = d;
                        });
                      },
                        items: [
                          DropdownMenuItem(
                            child: Container(
                              width: 100,
                              height: 10,
                              color: Colors.green,
                            ),
                            value: 1,
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 100,
                              height: 10,
                              color: Colors.blue,
                            ),
                            value: 3,
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 100,
                              height: 10,
                              color: Colors.yellow,
                            ),
                            value: 4,
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 100,
                              height: 10,
                              color: Colors.orange,
                            ),
                            value: 2,
                          )
                        ],
                        value : _colorChosen,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Form(
                        key: _formKey,
                          child:
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField( //input Title dari task
                              decoration: const InputDecoration(
                                hintText: 'Title',
                              ),
                              onSaved: (value) => _title = value,
                              validator: (value) => (value.trim().isEmpty) ? 'Please fill this text field' : null,

                            ),
                          ),

                          Row(
                            children:<Widget> [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Date',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(4.0)
                                    ),
                                    onTap: _selectDate,
                                    controller: _dateController,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10, width: 20,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: 'Time',
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(4.0)
                                    ),
                                    validator: (input) => input.trim().isEmpty ? 'Please enter todo time' : null,
                                    onSaved: (input) => _todoTime = input,
                                    initialValue: _todoTime,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  hintText: 'description',
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(4.0)
                              ),
                              validator: (input) => input.trim().isEmpty ? 'Please enter todo description' : null,
                              onSaved: (input) => _desc = input,
                              initialValue: _desc,
                            ),
                          ),
                        ],
                      )
                      )
                    ],
                  ),
                ],
              )
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange[400],
          onPressed: () => _submit(),
          child: Icon(Icons.check)
      ),
    );
  }
}

class AddTaskAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0, // in logical pixels
        decoration: BoxDecoration(color: Colors.blue[500]),
        // Row is a horizontal, linear layout.
        child: Row(
          // <Widget> is the type of items in the list.
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              tooltip: 'Back',
              onPressed: () => Navigator.pop(context)
            ),
            Expanded(
              child: Text(
                  'New',
                  style: Theme
                      .of(context) //
                      .primaryTextTheme
                      .headline6
              ),
            ),
          ],
        )
    );
  }
}