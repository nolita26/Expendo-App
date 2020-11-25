import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEvent extends StatefulWidget {
  final Function addEventFunc;
  NewEvent(this.addEventFunc);
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  var _isLoading = false;

  Future<void> _submitData() async {
    final _enteredTitle = _titleController.text;
    final _enteredDesc = _descriptionController.text;

    if (_enteredTitle.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.addEventFunc(
          _selectedDate, _enteredTitle, _enteredDesc, _selectedTime);
    } catch (error) {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An Error Occure'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Okay'),
                  )
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: _selectedDate,
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

  void _presentTimePicker() {
    showTimePicker(context: context, initialTime: _selectedTime)
        .then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        _selectedTime = pickedTime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = MaterialLocalizations.of(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
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
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: _descriptionController,
                      onSubmitted: (_) => _submitData(),
                    ),
                    Container(
                      height: 100.0,
                      child: Column(
                        children: [
                          Row(
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
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(_selectedTime == null
                                    ? 'No time chosen'
                                    : 'Picked time: ' +
                                        localization
                                            .formatTimeOfDay(_selectedTime)
                                            .toString()),
                              ),
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'Choose time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: _presentTimePicker,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      child: Text('Add Event'),
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
