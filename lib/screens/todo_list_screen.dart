import 'package:flutter/material.dart';
import 'package:to_do_project/screens/update_todo_screen.dart';
import 'add_new_todo_screen.dart';
import 'todo.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Todo> listOfTodo = [];

  void _addTodo(Todo todo) {
    listOfTodo.add(todo);
    setState(() {});
  }

  void _deleteTodo(int index) {
    listOfTodo.removeAt(index);
    setState(() {});
  }

  void _updateTodo(int index, Todo todo) {
    listOfTodo[index] = todo;
    setState(() {});
  }

  void _updateTodoStatus(int index, TodoStatus status) {
    listOfTodo[index].status = status;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),

      body: Visibility(
        visible: listOfTodo.isNotEmpty,
        replacement: Center(child: Text("Empty List")),
        child: ListView.builder(
          itemCount: listOfTodo.length,
          itemBuilder: (context, index) {
            Todo todo = listOfTodo[index];
            return ListTile(
              title: Text(todo.title),
              subtitle: Text(todo.description),
              leading: Text(todo.status.name),
              trailing: Wrap(
                children: [
                  IconButton(
                    onPressed: () {
                      _deleteTodo(index);
                    },
                    icon: Icon(Icons.delete),
                  ),

                  IconButton(
                    onPressed: () {
                      _showChangeStatusDialog(index);
                    },
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTodoScreen(
                      todo: todo,
                      onUpdateTodo: (Todo updatetodo) {
                        _updateTodo(index, updatetodo);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Todo? todo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewTodoScreen()),
          );
          if (todo != null) {
            _addTodo(todo);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showChangeStatusDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('change status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Idle'),
                onTap: () {
                  _onTapUpdateStatusButton(index, TodoStatus.idle);
                },
              ),
              Divider(height: 0),
              ListTile(
                title: Text('In progress'),
                onTap: () {
                  _onTapUpdateStatusButton(index, TodoStatus.inProgress);
                },
              ),
              Divider(height: 0),
              ListTile(
                title: Text('Done'),
                onTap: () {
                  _onTapUpdateStatusButton(index, TodoStatus.done);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTapUpdateStatusButton(int index, TodoStatus status) {
    _updateTodoStatus(index, status);
    Navigator.pop(context);
  }
}
