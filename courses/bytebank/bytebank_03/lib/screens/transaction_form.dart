import 'dart:async';

import 'package:bytebank_03/components/progress.dart';
import 'package:bytebank_03/components/response_dialog.dart';
import 'package:bytebank_03/components/transaction_auth_dialog.dart';
import 'package:bytebank_03/http/webclients/transaction_webclient.dart';
import 'package:bytebank_03/models/contact.dart';
import 'package:bytebank_03/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    print('Transaction form id $transactionId');
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(
                    message: 'Sending ...',
                  ),
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value != null) {
                        final transactionCreated =
                            Transaction(transactionId, value, widget.contact);
                        showDialog(
                            context: context,
                            builder: (contextDialog) => TransactionAuthDialog(
                                  onConfirm: (String password) {
                                    _save(
                                        transactionCreated, password, context);
                                  },
                                ));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    // await Future.delayed(Duration(seconds: 1)); //Delay only for test
    Transaction transaction = await _send(
      transactionCreated,
      password,
      context,
    );
    _showSuccessfullMessage(transaction, context);
  }

  Future<void> _showSuccessfullMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('Successfull transaction');
          });
      Navigator.pop(context); //Dialog close
    }
  }

  Future<Transaction> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    final Transaction transaction = await _webClient
        .save(transactionCreated, password)
        .catchError((onError) {
      _showFailureMessage(context, message: onError.message);
    }, test: (onError) => onError is TimeoutException).catchError((onError) {
      _showFailureMessage(context, message: onError.message);
    }, test: (onError) => onError is HttpException).catchError((onError) {
      _showFailureMessage(context);
    }).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknow error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}