import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double expenseAmount;
  final double expenseAmountPercentage;

  ChartBar(this.label, this.expenseAmount, this.expenseAmountPercentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\$${expenseAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                      //will inherit the height of the parent
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          color: Color.fromRGBO(220, 220, 220, 1),
                          borderRadius: BorderRadius.circular(10))),
                  FractionallySizedBox(
                    heightFactor: expenseAmountPercentage,
                    child: Container(
                        //will inherit the height of the fraction box
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
