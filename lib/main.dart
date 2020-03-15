import 'package:flutter/material.dart';

import './widgets/transactionList.widget.dart';
import './models/transaction.model.dart';
import './widgets/newTransactions.widget.dart';
import './widgets/chart.widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Badger",
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          fontFamily: 'Quicksand',
          //we can use this with a regular Text widget
          //appBarTheme: AppBarTheme(textTheme: ThemeData.light().textTheme.copyWith(title: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold)))
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: "t1",
      title: "New Shoes",
      amount: 49.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: "t2",
      title: "Groceries",
      amount: 89.99,
      date: DateTime.now(),
    )
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addTransaction(String expenseTitle, double expenseAmount) {
    final newTX = Transaction(
        id: DateTime.now().toString(),
        title: expenseTitle,
        amount: expenseAmount,
        date: DateTime.now());
    setState(() {
      _userTransactions.add(newTX);
    });
  }

  void _addExpenseModal(BuildContext ctx) {
    //inbuilt material method
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            //helps with ensuring modal doesnt close except we tap background
            onTap: () {},
            child: NewTransactions(_addTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text("Badger - Easy Budgets"),
          title: RichText(
            text: TextSpan(
              text: 'Badger | ',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor,
                  fontFamily: 'Acme',
                  fontSize: 18),
              children: <TextSpan>[
                TextSpan(
                    text: 'Expense Tracker',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontFamily: 'Quicksand')),
              ],
            ),
          ),
          //backgroundColor: Colors.pink,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.insert_invitation,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () => _addExpenseModal(context)),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _addExpenseModal(context),
          //backgroundColor: Colors.pink,
        ), //where this is placed doesnt matter
        body: SingleChildScrollView(
          //allows us to scroll!
          child: Column(
            children: <Widget>[
              Chart(_recentTransactions),
              TransactionList(_userTransactions)
            ],
          ),
        ));
  }
}
