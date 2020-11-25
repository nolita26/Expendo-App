import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/new_transaction.dart';
import '../model/transaction.dart';
import '../widgets/transaction_list.dart';
import 'package:http/http.dart' as http;
import '../widgets/chart.dart';

class ExpensesPage extends StatefulWidget {
  static const routeName = '/expenses';
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Transaction> _userTransactions = [];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  Future<void> _addNewTransaction(
      String title, double amount, DateTime chosenDate) async {
    const url = 'https://expendo-5dd9e.firebaseio.com/transactions.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': title,
            'amount': amount,
            'date': chosenDate.microsecondsSinceEpoch,
          }));

      final newTx = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: json.decode(response.body)['name'],
      );

      setState(() {
        _userTransactions.add(newTx);
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetTransactions() async {
    const url = 'https://expendo-5dd9e.firebaseio.com/transactions.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Transaction> loadedTransaction = [];
      extractedData.forEach((transactionId, transaction) {
        loadedTransaction.add(Transaction(
            amount: transaction['amount'],
            date: DateTime.fromMicrosecondsSinceEpoch(transaction['date']),
            id: transactionId,
            title: transaction['title']));
      });

      setState(() {
        _userTransactions = loadedTransaction;
        // print(_userTransactions);
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> _deleteTransaction(String id) async {
    final url = 'https://expendo-5dd9e.firebaseio.com/transactions/$id.json';
    final existingTransactionIndex =
        _userTransactions.indexWhere((element) => element.id == id);
    var existingTransaction = _userTransactions[existingTransactionIndex];
    setState(() {
      _userTransactions.removeAt(existingTransactionIndex);
    });
    http.delete(url).then((_) => existingTransaction = null).catchError((_) {
      setState(() {
        _userTransactions.insert(existingTransactionIndex, existingTransaction);
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  Future<void> _refreshTransaction() async {
    await fetchAndSetTransactions();
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
      fetchAndSetTransactions().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context))
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: RefreshIndicator(
            onRefresh: _refreshTransaction,
            child: TransactionList(_userTransactions, _deleteTransaction)));

    final pageBody = SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (isLandscape)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Show Chart',
                              style: Theme.of(context).textTheme.title),
                          Switch.adaptive(
                            activeColor: Theme.of(context).accentColor,
                            value: _showChart,
                            onChanged: (val) {
                              setState(() {
                                _showChart = val;
                              });
                            },
                          ),
                        ],
                      ),
                    if (!isLandscape)
                      Container(
                          height: (mediaQuery.size.height -
                                  appBar.preferredSize.height -
                                  mediaQuery.padding.top) *
                              0.3,
                          child: Chart(_recentTransactions)),
                    if (!isLandscape) txListWidget,
                    if (isLandscape)
                      _showChart
                          ? Container(
                              height: (mediaQuery.size.height -
                                      appBar.preferredSize.height -
                                      mediaQuery.padding.top) *
                                  0.7,
                              child: Chart(_recentTransactions))
                          : txListWidget
                  ],
                ),
              ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
