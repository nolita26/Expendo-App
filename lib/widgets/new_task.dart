import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTask extends StatefulWidget {
  final Function addTaskFunc;

  NewTask(this.addTaskFunc);
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final _enteredTitle = _titleController.text;

    if (_enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }

    widget.addTaskFunc(_selectedDate, _enteredTitle);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime(2101))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 100.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No date chosen'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Task'),
                onPressed: _submitData,
                textColor: Theme.of(context).textTheme.button.color,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
