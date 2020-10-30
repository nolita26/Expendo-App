import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/model/database.dart';
import 'package:todoapp/pages/login_page.dart';
import 'package:todoapp/pages/add_event_page.dart';
import 'package:todoapp/pages/add_task_page.dart';
import 'package:todoapp/pages/event_page.dart';
import 'package:todoapp/pages/task_page.dart';
import 'package:todoapp/widgets/custom_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<Database>(builder: (_) => Database())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.purple, fontFamily: "Montserrat"),
        home: Splash(),
      ));
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
        navigateAfterSeconds: Login(),
//      TODO: Add Wrapper , Once Firebase Authentication is sorted
      ),
    );
  }
}
