import 'package:flutter/material.dart';

class NewTransactions extends StatefulWidget {
  final Function addExpense;
  NewTransactions(this.addExpense);

  @override
  _NewTransactionsState createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  final expenseInputController = TextEditingController();

  final amountInputController = TextEditingController();

  void submitData(){
    final expenseInput = expenseInputController.text;
    final amountInput = double.parse(amountInputController.text);
    //quick validation here. Exit the function if values are not available
    if(expenseInput.isEmpty || amountInput <= 0){
      return;
    }

    widget.addExpense(expenseInput, amountInput);

    //close add expense modal once we are done
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            TextField(
              cursorColor: Colors.pink,
              decoration: InputDecoration(labelText: 'Expense name'),
              //onChanged: (value){expenseNameInput = value;},
              controller: expenseInputController,
              onSubmitted: (_) => submitData(),
            ),
            TextField(
              cursorColor: Colors.pink,
              decoration: InputDecoration(labelText: 'Amount spent'),
              //onChanged: (value){amountSpentInput = value;},
              controller: amountInputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (_) => submitData(),
            ),
            FlatButton(
              onPressed: submitData,
              child: Text('Save Expense'),
              color: Colors.pink,
              textColor: Colors.white,
            )
          ]),
        ));
  }
}
