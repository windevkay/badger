import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.model.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;
  TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          350, //this here allows the tx list to be able to scroll independently of the main home page
      child: userTransactions.isEmpty
          ? Column(children: <Widget>[
              Text('No transactions yet! Add an expense.',
                  style: Theme.of(context).textTheme.title),
              SizedBox(
                height: 30,
              ), //spacer!
              Container(
                  height: 200,
                  alignment: Alignment(0.0, 0.0), //center elements
                  child: Image.asset(
                    'images/badgerrr.png',
                    fit: BoxFit.cover,
                  ))
            ])
          : ListView.builder(
              //builder lazy loads items in the list . better for performance
              itemBuilder: (ctx, index) {
                // return Card(
                //   elevation: 10,
                //   child: Row(
                //     children: <Widget>[
                //       Container(
                //         margin:
                //             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                //         padding: EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: Theme.of(context).accentColor, width: 0.5),
                //               borderRadius: BorderRadius.circular(10)
                //         ),
                //         child: Text(
                //           '\$${userTransactions[index].amount.toStringAsFixed(2)}',
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15,
                //               color: Theme.of(context).primaryColor),
                //         ),
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Text(
                //             userTransactions[index].title,
                //             style: Theme.of(context).textTheme.title,
                //           ),
                //           Text(
                //             DateFormat().format(userTransactions[index].date),
                //             style: TextStyle(color: Colors.grey, fontSize: 12),
                //           ),
                //         ],
                //       )
                //     ],
                //   ),
                // );
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                              '\$${userTransactions[index].amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(
                      userTransactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(userTransactions[index].date),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          deleteTransaction(userTransactions[index].id),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
