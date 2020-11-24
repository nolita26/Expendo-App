import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/widgets/new_task.dart';
// import 'package:provider/provider.dart';
// import '../model/database.dart';
import '../model/todo.dart';
import '../widgets/custom_button.dart';

class TaskPage extends StatefulWidget {
  @override
  TaskPageState createState() => TaskPageState();
}

class TaskPageState extends State<TaskPage> {
  final List<Todo> todos = [
    Todo(
      date: DateTime.now(),
      description: "This is a task",
      id: DateTime.now().toString(),
      isFinish: false,
      task: "Dummy Task",
      time: DateTime.now(),
      todoType: TodoType.TYPE_TASK.index,
    )
  ];

  void addNewTodo(DateTime date, String task) {
    setState(() {
      todos.add(Todo(
          date: date,
          description: "",
          id: DateTime.now().toString(),
          isFinish: false,
          task: task,
          time: DateTime.now(),
          todoType: TodoType.TYPE_TASK.index));
    });
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

  @override
  Widget build(BuildContext context) {
    // provider = Provider.of<Database>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _startAddNewTask(context);
          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     builder: (BuildContext context) {
          //       return Dialog(
          //           child: currentPage == 0 ? AddTaskPage() : AddEventPage(),
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(12))));
          //     });
        },
        child: Icon(Icons.add),
      ),
      body: todos.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
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
    );
  }

  // StreamProvider<List<TodoData>> buildStreamProviderFunction() {
  //   return StreamProvider.value(
  //     value: provider.getTodoByType(TodoType.TYPE_TASK.index),
  //     child: Consumer<List<TodoData>>(
  //       builder: (context, _dataList, child) {
  //         return _dataList == null
  //             ? Center(child: CircularProgressIndicator())
  //             : ListView.builder(
  //                 padding: const EdgeInsets.all(0),
  //                 itemCount: _dataList.length,
  //                 itemBuilder: (context, index) {
  //                   return _dataList[index].isFinish
  //                       ? _taskComplete(_dataList[index])
  //                       : _taskUncomplete(_dataList[index]);
  //                 },
  //               );
  //       },
  //     ),
  //   );
  // }

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
                        onPressed: () {
                          // provider
                          //     .completeTodoEntries(data.id)
                          //     .whenComplete(() => Navigator.of(context).pop());

                          setState(() {
                            todos[index].isFinish = true;
                          });
                          Navigator.of(context).pop();
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
                        onPressed: () {
                          // provider
                          //     .deleteTodoEntries(data.id)
                          //     .whenComplete(() => Navigator.of(context).pop());

                          setState(() {
                            todos.removeAt(index);
                          });
                          Navigator.of(context).pop();
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
