import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/add_task.dart';
import 'package:todo_list_app/todo_card.dart';
import 'package:todo_list_app/task.dart';
import 'package:todo_list_app/database_helper.dart';


class ToDoList extends StatefulWidget {
  const ToDoList({Key key}) : super(key: key);
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isFinished = false;
  /*
  List<Task> hardcodeTasks = [
    Task(name:"Kerja",todoDate: "Today",todoTime: "10 AM", description: "Gitulah pokoknya", colorTag: Task.ORANGE_COLOR, isFinalized: true),
    Task(name:"Kerja2",todoDate: "besok",todoTime: "9 AM", description: "Gitulah pokoknya(2)", colorTag: Task.BLUE_COLOR, isFinalized: false)
  ];
   */

  Future<List<Task>> _displayedTodos;

  @override
  void initState(){
    super.initState();
    _updateTodoList();
  }

  _updateTodoList() {
    setState(() {
      _displayedTodos = DatabaseHelper.instance.getTodoList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Things To Do"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
          ),
          PopupMenuButton(
            icon: Icon(Icons.sort),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: <Widget> [
                  Text("Status"),
                    SizedBox(width : 5),
                    Checkbox(
                        value: isFinished,
                        activeColor: Colors.orange[400],
                        onChanged: (newValue){
                          setState(() {
                            isFinished = newValue;
                          });
                        }),
                ],
                ),
              ),
              PopupMenuItem(
                child: Text("Date"),
              ),
              PopupMenuItem(
                child: Text("Priority"),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(updateTodos: _updateTodoList))),
          child: Icon(Icons.add)
      ),
      body: SafeArea(
        child: FutureBuilder<List<Task>>(
          future: _displayedTodos,
          builder: (context,snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('No Data'),
              );
            }
            return Container(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return TodoCard(task: snapshot.data[index],
                      updateTodos: _updateTodoList,);
                  },
                )
            );
          }),
    ),
    );
  }
}
