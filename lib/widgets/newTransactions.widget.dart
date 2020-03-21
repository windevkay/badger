import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransactions extends StatefulWidget {
  final Function addExpense;
  NewTransactions(this.addExpense);

  @override
  _NewTransactionsState createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  final _expenseInputController = TextEditingController();
  final _amountInputController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final expenseInput = _expenseInputController.text;
    final amountInput = double.parse(_amountInputController.text);
    //quick validation here. Exit the function if values are not available
    if (expenseInput.isEmpty || amountInput <= 0 || _selectedDate == null) {
      return;
    }

    widget.addExpense(expenseInput, amountInput, _selectedDate);

    //close add expense modal once we are done
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    //inbuilt flutter widget
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Container(
            //the padding format here ensures we can scroll text fields above the keyboard
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(children: <Widget>[
              TextField(
                cursorColor: Colors.pink,
                decoration: InputDecoration(labelText: 'Expense name'),
                //onChanged: (value){expenseNameInput = value;},
                controller: _expenseInputController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                cursorColor: Colors.pink,
                decoration: InputDecoration(labelText: 'Amount spent'),
                //onChanged: (value){amountSpentInput = value;},
                controller: _amountInputController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Selected'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    FlatButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _submitData,
                child: Text('Save Expense'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              )
            ]),
          )),
    );
  }
}
