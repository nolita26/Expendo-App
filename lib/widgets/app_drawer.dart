import 'package:flutter/material.dart';
import '../pages/expenses_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Tasks'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Expenses'),
            onTap: () {
              Navigator.of(context).pushNamed(ExpensesPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Other options'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
