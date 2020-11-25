import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:todoapp/widgets/new_event.dart';
import '../widgets/custom_icon_decoration.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class Event {
  // final String time;
  final String time;
  final String task;
  final String desc;
  bool isFinish;
  final DateTime date;

  Event({this.time, this.task, this.desc, this.isFinish, this.date});
}

class _EventPageState extends State<EventPage> {
  List<Event> _eventList = [];

  Future<void> addNewEvent(
      DateTime date, String task, String desc, TimeOfDay time) async {
    const url = 'https://expendo-5dd9e.firebaseio.com/events.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'time': time.toString(),
            'desc': desc,
            'isFinish': false,
            'task': task,
            'date': date.microsecondsSinceEpoch
          }));

      setState(() {
        _eventList.add(
          Event(
            time: time.toString(),
            desc: desc,
            isFinish: false,
            task: task,
            date: date,
          ),
        );
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetEvents() async {
    const url = 'https://expendo-5dd9e.firebaseio.com/events.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Event> loadedEvent = [];
      extractedData.forEach((eventId, event) {
        loadedEvent.add(Event(
            date: DateTime.fromMicrosecondsSinceEpoch(event['date']),
            desc: event['desc'],
            isFinish: event['isFinish'],
            task: event['task'],
            time: event['time']));
      });

      setState(() {
        _eventList = loadedEvent;
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> _refreshEvents() async {
    await fetchAndSetEvents();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      fetchAndSetEvents().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _startAddNewEvent(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewEvent(addNewEvent),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _startAddNewEvent(context);
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _eventList.isEmpty
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
                    itemCount: _eventList.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24),
                        child: Row(
                          children: <Widget>[
                            _lineStyle(context, iconSize, index,
                                _eventList.length, _eventList[index].isFinish),
                            _displayTime(_eventList[index].time),
                            _displayContent(_eventList[index])
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _displayContent(Event event) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.task),
              SizedBox(
                height: 12,
              ),
              Text(event.desc)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTime(String time) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(time.toString()),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
        decoration: CustomIconDecoration(
            iconSize: iconSize,
            lineWidth: 1,
            firstData: index == 0 ?? true,
            lastData: index == listLength - 1 ?? true),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    color: Color(0x20000000),
                    blurRadius: 5)
              ]),
          child: Icon(
              isFinish
                  ? Icons.fiber_manual_record
                  : Icons.radio_button_unchecked,
              size: iconSize,
              color: Colors.deepPurple),
        ));
  }
}
