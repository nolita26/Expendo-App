import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/widgets/new_event.dart';
import '../widgets/custom_icon_decoration.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class Event {
  // final String time;
  final TimeOfDay time;
  final String task;
  final String desc;
  bool isFinish;
  final DateTime date;

  Event({this.time, this.task, this.desc, this.isFinish, this.date});
}

class _EventPageState extends State<EventPage> {
  final List<Event> _eventList = [
    Event(
      time: TimeOfDay.now(),
      desc: "This is a dummy event",
      isFinish: false,
      task: "Dummy event",
      date: DateTime.now(),
    ),
  ];

  void addNewEvent(DateTime date, String task, String desc, TimeOfDay time) {
    setState(() {
      _eventList.add(
        Event(
          time: time,
          desc: desc,
          isFinish: false,
          task: task,
          date: date,
        ),
      );
    });
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
      body: ListView.builder(
        itemCount: _eventList.length,
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: Row(
              children: <Widget>[
                _lineStyle(context, iconSize, index, _eventList.length,
                    _eventList[index].isFinish),
                _displayTime(_eventList[index].time),
                _displayContent(_eventList[index])
              ],
            ),
          );
        },
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

  Widget _displayTime(TimeOfDay time) {
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
