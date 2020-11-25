import 'package:flutter/material.dart';
import '../pages/expenses_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome to Expendo!'),
            backgroundColor: Colors.deepPurple,
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Tasks', style: TextStyle(fontSize: 16),),
            onTap: () {
              Navigator.of(context).pushNamed(ExpensesPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Events', style: TextStyle(fontSize: 16),),
            onTap: () {
              Navigator.of(context).pushNamed(ExpensesPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Expenses', style: TextStyle(fontSize: 16),),
            onTap: () {
              Navigator.of(context).pushNamed(ExpensesPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings', style: TextStyle(fontSize: 16),),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate Us!', style: TextStyle(fontSize: 16),),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
