import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todoapp/widgets/new_task.dart';

import '../model/todo.dart';
import '../widgets/custom_button.dart';
import 'dart:async';

class TaskPage extends StatefulWidget {
  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  List<Todo> todos = [];

  Future<void> addNewTodo(DateTime date, String task) async {
    const url = 'https://expendo-5dd9e.firebaseio.com/tasks.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'date': date.microsecondsSinceEpoch,
            'description': "",
            'isFinish': false,
            'task': task,
            'time': DateTime.now().microsecondsSinceEpoch,
            'todoType': TodoType.TYPE_TASK.index
          }));

      setState(() {
        todos.add(Todo(
            date: date,
            description: "",
            id: json.decode(response.body)['name'],
            isFinish: false,
            task: task,
            time: DateTime.now(),
            todoType: TodoType.TYPE_TASK.index));
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void _startAddNewTask(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTask(addNewTodo),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  Future<void> fetchAndSetTasks() async {
    const url = 'https://expendo-5dd9e.firebaseio.com/tasks.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Todo> loadedTodo = [];
      extractedData.forEach((todoId, todo) {
        loadedTodo.add(
          Todo(
              id: todoId,
              date: DateTime.fromMicrosecondsSinceEpoch(todo['date']),
              time: DateTime.fromMicrosecondsSinceEpoch(todo['time']),
              task: todo['task'],
              description: todo['description'],
              isFinish: todo['isFinish'],
              todoType: todo['todoType']),
        );
      });
      setState(() {
        todos = loadedTodo;
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateTodo(String id, Todo newTodo) async {
    final url = 'https://expendo-5dd9e.firebaseio.com/tasks/$id.json';
    await http.patch(
      url,
      body: json.encode({
        'date': newTodo.date.microsecondsSinceEpoch,
        'description': newTodo.description,
        'isFinish': true,
        'task': newTodo.task,
        'time': newTodo.time.microsecondsSinceEpoch,
        'todoType': newTodo.todoType
      }),
    );
  }

  Future<void> deleteTodo(String id) async {
    final url = 'https://expendo-5dd9e.firebaseio.com/tasks/$id.json';
    final existingTodoIndex = todos.indexWhere((element) => element.id == id);
    var existingTodo = todos[existingTodoIndex];
    setState(() {
      todos.removeAt(existingTodoIndex);
    });
    http.delete(url).then((_) => existingTodo = null).catchError((_) {
      setState(() {
        todos.insert(existingTodoIndex, existingTodo);
      });
    });
  }

  Future<void> _refreshTasks() async {
    await fetchAndSetTasks();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // fetchAndSetTasks();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      fetchAndSetTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // provider = Provider.of<Database>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _startAddNewTask(context);
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTasks,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : todos.isEmpty
                ? LayoutBuilder(builder: (ctx, constraints) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'No todos added yet!',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                              height: constraints.maxHeight * 0.6,
                              child: Image.asset(
                                'assets/image/waiting.png',
                                fit: BoxFit.cover,
                              ))
                        ],
                      ),
                    );
                  })
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (ctx, index) {
                      return todos[index].isFinish
                          ? _taskComplete(todos[index], index)
                          : _taskUncomplete(todos[index], index);
                    },
                    itemCount: todos.length,
                  ),
      ),
    );
  }

  Widget _taskUncomplete(Todo data, int index) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Confirm Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),
                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Complete",
                        onPressed: () async {
                          // provider
                          //     .completeTodoEntries(data.id)
                          //     .whenComplete(() => Navigator.of(context).pop());

                          setState(() {
                            todos[index].isFinish = true; //local update
                          });
                          await updateTodo(todos[index].id, todos[index])
                              .then((_) {
                            Navigator.of(context).pop();
                          }); //api call
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            });
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Delete Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data.task),
                      SizedBox(
                        height: 24,
                      ),
                      Text(new DateFormat("dd-MM-yyyy").format(data.date)),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Delete",
                        onPressed: () async {
                          // provider
                          //     .deleteTodoEntries(data.id)
                          //     .whenComplete(() => Navigator.of(context).pop());
                          await deleteTodo(todos[index].id).then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_unchecked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Text(data.task)
          ],
        ),
      ),
    );
  }

  Widget _taskComplete(Todo data, int index) {
    return Container(
      foregroundDecoration: BoxDecoration(color: Color(0x60FDFDFD)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_checked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Text(data.task)
          ],
        ),
      ),
    );
  }
}
