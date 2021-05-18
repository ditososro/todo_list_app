import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/task.dart';
import 'package:todo_list_app/database_helper.dart';

class TodoCard extends StatelessWidget {
  final Task task;

  final Function updateTodos;
  TodoCard({this.task,this.updateTodos});

  @override
  Widget build(BuildContext context) {
    return Card(
    child: CheckboxListTile(
      title: Text(task.name,
          style: TextStyle(
            fontSize: 18,
            decoration: task.isFinalized !=1 ? TextDecoration.lineThrough : null,
          )
      ),
      onChanged: (value) {
        task.isFinalized = value ? 1 : 0;
        DatabaseHelper.instance.updateTodo(task);
        updateTodos();
      },
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
      Text(
      task.description,
        style: TextStyle(
          fontSize: 10,
          decoration: task.isFinalized !=1 ? TextDecoration.lineThrough : null,
        ),
      ),
          Text(
            "${task.todoDate}  ${task.todoTime}",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: task.isFinalized !=1 ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
      isThreeLine: true,
      value: task.isFinalized == 1,
    secondary: Container(
        height: double.infinity,
        width: 5,
        color: task.getColor()),
    )
    );
  }
}


