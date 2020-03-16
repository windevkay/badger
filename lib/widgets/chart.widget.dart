import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.model.dart';
import './chartBar.widget.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  //we can use a getter here to generate objects with a predefined number
  //in this case 7 objects representing the days of the week
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      //get the total amount expensed per day
      double totalSpend = 0.0;

      //loop through the transactions and collate the amounts matching the weekday
      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSpend += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSpend
      };
    }).reversed.toList();
  }

  double get totalMaxExpenses {
    return groupedTransactionValues.fold(0.0, (sum, trx) {
      return sum + trx['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalMaxExpenses == 0
                      ? 0.0
                      : (data['amount'] as double) / totalMaxExpenses),
            );
          }).toList(),
        ),
      ),
    );
  }
}
