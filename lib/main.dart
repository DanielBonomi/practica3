import 'dart:math';

import 'package:flutter/material.dart';
import 'package:practica3/BankService.dart';


import 'Account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BankService _service = BankService();

  @override
  void initState() {
    super.initState();
    // init HERE
  }

  void _addAccount() {
    setState(() {
      _service.createAccount(Random().nextDouble().toString().substring(2));
    });
  }


  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void executeTransaction(
    String? type,
    String? targetAccount,
    double amount,
    String? sourceAccount,
  ) {


    if (! {'Transfer','Deposit','Withdraw'}.contains(type)) {
      throw ArgumentError("Transaction in interface has invalid type");
    }

    try {
      if (type == 'Transfer') {
        _service.transfer(sourceAccount!, targetAccount!, amount);
      } else if (type == 'Deposit') {
        _service.deposit(targetAccount!, amount);
      } else if (type == 'Withdraw') {
        _service.withdrawal(targetAccount!, amount);
      }
    } catch (error) {
      _showMessage(error.toString());
    }



    setState(() {

    });
  }

  void _showTransactionDialog(
    BuildContext context,
    Map<String, Account> accounts,
  ) {
    String? transactionType;
    double amount = 0.0;
    String? targetAccount;
    String? sourceAccount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: Text('Select Transaction Type'),
                    value: transactionType,
                    onChanged: (String? newValue) {
                      setState(() {
                        transactionType = newValue;
                        sourceAccount = null;
                      });
                    },
                    items:
                        <String>[
                          'Transfer',
                          'Deposit',
                          'Withdraw',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      amount = double.tryParse(value) ?? 0.0;
                    },
                  ),
                  if (transactionType == 'Transfer') ...[
                    DropdownButton<String>(
                      hint: Text('Select Source Account'),
                      value: sourceAccount,
                      onChanged: (String? newValue) {
                        setState(() {
                          sourceAccount = newValue;
                        });
                      },
                      items:
                      accounts.keys.map<DropdownMenuItem<String>>((
                          String key,
                          ) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Text(key),
                        );
                      }).toList(),
                    ),
                  ],
                  DropdownButton<String>(
                    hint: Text('Select Target Account'),
                    value: targetAccount,
                    onChanged: (String? newValue) {
                      setState(() {
                        targetAccount = newValue;
                      });
                    },
                    items:
                        accounts.keys.map<DropdownMenuItem<String>>((
                          String key,
                        ) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(key),
                          );
                        }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // CALL TO MY METHOD
                    executeTransaction(
                      transactionType,
                      targetAccount,
                      amount,
                      sourceAccount,
                    );
                  },
                  child: Text('Submit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My ListView')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _service.accounts.length,
                itemBuilder: (context, index) {
                  String key = _service.accounts.keys.elementAt(index);
                  String value = _service.accounts[key]!.balance.toString();
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(value),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action for the first button
                      _addAccount();
                    },
                    child: Text('Add account'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showTransactionDialog(context, _service.accounts);
                    },
                    child: Text('Execute Transaction'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
