import 'package:flutter/material.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:todoapp/pages/get_started.dart';

import './pages/event_page.dart';
import './pages/task_page.dart';
import './widgets/custom_button.dart';
import './widgets/app_drawer.dart';
import './pages/expenses_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expendo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        errorColor: Colors.purple,
        fontFamily: 'Montserrat-Regular',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: new Splash(),
      initialRoute: "/",
      routes: {
        ExpensesPage.routeName: (ctx) => ExpensesPage(),
      },
    );
  }
}

//splash

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController();

  double currentPage = 0;

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('EXPENDO'),
      ),
      drawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            child: Text(
              DateTime.now().day.toString(),
              style: TextStyle(fontSize: 200, color: Color(0x10000000)),
            ),
          ),
          _mainContent(context),
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 15),
          child: Text(
            "Tuesday",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _button(context),
        ),
        Expanded(
            child: PageView(
          controller: _pageController,
          children: <Widget>[
            TaskPage(),
            EventPage(),
          ],
        ))
      ],
    );
  }

  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomButton(
              onPressed: () {
                _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
              },
              buttonText: "Tasks",
              color: currentPage < 0.5
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              textColor: currentPage < 0.5
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              borderColor: currentPage < 0.5
                  ? Colors.transparent
                  : Theme.of(context).primaryColor),
        ),
        SizedBox(
          width: 32,
        ),
        Expanded(
            child: CustomButton(
          onPressed: () {
            _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut);
          },
          buttonText: "Events",
          color:
              currentPage > 0.5 ? Theme.of(context).primaryColor : Colors.white,
          textColor:
              currentPage > 0.5 ? Colors.white : Theme.of(context).primaryColor,
          borderColor: currentPage > 0.5
              ? Colors.transparent
              : Theme.of(context).primaryColor,
        ))
      ],
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SplashScreen(
      seconds: 5,
      backgroundColor: Colors.white,
      image: Image.asset('images/logo.png'),
      loaderColor: Colors.black,
      photoSize: 120.0,
      navigateAfterSeconds: new GetStarted(),
      routeName: "/",
    ));
  }
}
