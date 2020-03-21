import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './widgets/transactionList.widget.dart';
import './models/transaction.model.dart';
import './widgets/newTransactions.widget.dart';
import './widgets/chart.widget.dart';

//to disable or configure device to be strictly used in portrait or landscape modes
void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(MyApp());
}

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

  //var to handle toggle for viewing expense chart or not
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addTransaction(
      String expenseTitle, double expenseAmount, DateTime expenseDate) {
    final newTX = Transaction(
        id: DateTime.now().toString(),
        title: expenseTitle,
        amount: expenseAmount,
        date: expenseDate);
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

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //general media query that we use
    final mediaQuery = MediaQuery.of(context);
    //to control views between landscape and portrait
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
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
    );

    //this is being stored as a var for conditional rendering purposes
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.65,
        child: TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
        appBar: appBar,
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
              //if here isnt meant to have a body, just renders the widget following it if true
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Toggle View'),
                    Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          //the val in switch gives us a boolean
                          _showChart = val;
                        });
                      },
                    ),
                  ],
                ),
              if (!isLandscape)
                Container(
                    //this is why we made appbar a variable, so we could access its height property
                    //media query helps us get the height of device screen
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.25,
                    child: Chart(_recentTransactions)),

              if (!isLandscape)
                txListWidget,

              if (isLandscape)
                _showChart
                    ? Container(
                        //this is why we made appbar a variable, so we could access its height property
                        //media query helps us get the height of device screen
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            0.7,
                        child: Chart(_recentTransactions))
                    : txListWidget
            ],
          ),
        ));
  }
}
