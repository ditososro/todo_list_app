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

  bool isDoneFilterOn;

  Widget appBarTitle;
  IconData appBarSearchIcon;
  Future<List<Task>> _displayedTodos;

  @override
  void initState(){
    super.initState();
    _updateTodoList(false);
    appBarSearchIcon = Icons.search;
    appBarTitle = Text('Things to do');
    isDoneFilterOn = false;
  }

  _updateTodoList(statusFilter) {
    if(statusFilter){
      setState(() {
        _displayedTodos = DatabaseHelper.instance.getDoneTodoList();
      });
    }
    else{
      setState(() {
        _displayedTodos = DatabaseHelper.instance.getTodoList();
      });
    }
  }

  _searchTodoList(queryString){
    setState(() {
      _displayedTodos = DatabaseHelper.instance.searchTodoList(queryString);
      appBarSearchIcon = Icons.search;
      appBarTitle = Text('Things to do');
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
                child: IconButton(
                  icon: Icon(
                    appBarSearchIcon,
                    color: Colors.white,
                  ),
                  tooltip: 'Search',
                  onPressed: (){
                    if (appBarSearchIcon == Icons.search) {
                      setState(() {
                        appBarSearchIcon = Icons.close;
                        appBarTitle = TextField(
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Search todos",
                            isDense: true,
                            contentPadding: EdgeInsets.all(4.0),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          onSubmitted: (searchKey){
                            _searchTodoList(searchKey);
                          },
                        );
                      });
                    }
                    else{
                      setState(() {
                        appBarSearchIcon = Icons.search;
                        appBarTitle = Text('Things to do');
                      });
                    }

                  },
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
                        value: isDoneFilterOn, onChanged: (newValue){
                      setState(() {
                        isDoneFilterOn = newValue;
                      });
                      _updateTodoList(isDoneFilterOn);
                    })
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
